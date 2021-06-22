# frozen_string_literal: true

require 'graphql/rake_task'

GraphQL::RakeTask.new(
  schema_name: 'SimpleTodoBackendSchema',
  idl_outfile: 'simple_todo_backend_schema.graphql',
)
