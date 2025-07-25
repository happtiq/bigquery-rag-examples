
WITH search_embedding AS (
  SELECT 
    ml_generate_embedding_result as article_embedding
  FROM ML.GENERATE_EMBEDDING(
    MODEL `@project.@dataset.embedding`,
    (SELECT '@search_text' as content),
    STRUCT(
      TRUE AS flatten_json_output,
      'RETRIEVAL_DOCUMENT' as task_type
    )
  )
),

-- Create the embeddings CTE with row_num for the search
embeddings AS (
  SELECT 
    0 as row_num, 
    article_embedding
  FROM search_embedding
)

-- Main vector search query
SELECT 
  base.*,
  query.row_num,
  distance AS score
FROM VECTOR_SEARCH(
  (SELECT * FROM `@project.@dataset.@table`),
  "article_embedding",
  (SELECT row_num, article_embedding FROM embeddings),
  distance_type => "COSINE",
  top_k => @top_k,
  options => '{"fraction_lists_to_search":@fraction}'
)
ORDER BY score DESC;