CREATE OR REPLACE VECTOR INDEX
  `@index_name`
ON `@project.@dataset.@table`
(article_embedding)
STORING (source_date)
OPTIONS(
  distance_type="COSINE",
  index_type="IVF"
)