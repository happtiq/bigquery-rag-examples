CREATE OR REPLACE MODEL @dataset.embedding
  REMOTE WITH CONNECTION `@project.@region.embeddings`
  OPTIONS (endpoint = 'text-multilingual-embedding-002');