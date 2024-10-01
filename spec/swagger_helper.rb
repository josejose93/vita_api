# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      servers: [
        {
          url: 'https://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'vita-api-603504249c56.herokuapp.com'
            }
          }
        }
      ],
      components: {
        schemas: {
          BtcPriceResponse: {
            type: :object,
            properties: {
              btc_price_usd: { type: :string }
            },
            required: ['btc_price_usd']
          },
          Transaction: {
            type: :object,
            properties: {
              id: { type: :integer },
              user_id: { type: :integer },
              currency_sent: { type: :string },
              currency_received: { type: :string },
              amount_sent: { type: :string },
              amount_received: { type: :string },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' }
            },
            required: %w[id user_id currency_sent currency_received amount_sent amount_received created_at updated_at]
          },
          TransactionList: {
            type: :array,
            items: { '$ref' => '#/components/schemas/Transaction' }
          },
          TransactionCreateInput: {
            type: :object,
            properties: {
              user_id: { type: :integer },
              currency_sent: { type: :string, enum: ['USD', 'BTC'] },
              currency_received: { type: :string, enum: ['USD', 'BTC'] },
              amount_sent: { type: :number, format: :float }
            },
            required: ['user_id', 'currency_sent', 'currency_received', 'amount_sent']
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml
end
