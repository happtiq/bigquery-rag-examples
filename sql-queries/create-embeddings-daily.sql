-- Insert new embeddings for documents from previous day
INSERT INTO `@project.@dataset.@table_vectors`
SELECT 
  article_id,
  article_content,
  article_embedding,
  source_id,
  source_date,
  source_start_page,
  source_file,
  author_id,
  author_name,
  ressort,
  sub_headline,
  title,
  sub_title,
  contentstore,
  article_type
FROM (
  SELECT 
    t.*,
    e.ml_generate_embedding_result as article_embedding
  FROM (
    SELECT 
      article_id,
      article_content,
      source_date,
      source_id,
      source_start_page,
      source_file,
      author_id,
      author_name,
      ressort,
      sub_headline,
      title,
      sub_title,
      contentstore,
      article_type
    FROM `@project.@dataset.@table_source`
    WHERE DATE(source_date) = DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)
  ) t
  CROSS JOIN ML.GENERATE_EMBEDDING(
    MODEL `@project.@dataset.embedding`,
    (SELECT article_content as content, title 
     FROM `@project.@dataset.@table_source` 
     WHERE DATE(source_date) = DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)),
    STRUCT(
      TRUE AS flatten_json_output,
      'RETRIEVAL_DOCUMENT' as task_type
    )
  ) e
);