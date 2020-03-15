# frozen_string_literal: true

class HelplineSchema < GraphQL::Schema
  default_max_page_size 50
  mutation(Types::MutationType)
  query(Types::QueryType)

  use GraphQL::Execution::Interpreter
  use GraphQL::Analysis::AST
  use GraphQL::Pagination::Connections
  use GraphQL::Batch
end
