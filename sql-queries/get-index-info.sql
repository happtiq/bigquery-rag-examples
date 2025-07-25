SELECT
  *
FROM
  `@project.@dataset.INFORMATION_SCHEMA.VECTOR_INDEXES`
WHERE
  index_name = "@index_name";
