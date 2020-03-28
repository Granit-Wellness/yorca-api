# frozen_string_literal: true

module Sequel
  module Plugins
    module Batch
      module DatasetMethods
        def batch_map(column: :iid, page_size: 1_000)
          results = []

          select_append(column).batch_row(page_size, column) do |result|
            if block_given?
              results << yield(result)
            else
              results << result
            end
          end

          results
        end

        def each_batch(batch_size: 10_000, column: :iid, page_size: 1_000)
          batch = []

          each_page(column: column, page_size: page_size) do |result|
            batch += result

            if batch.length >= batch_size
              yield batch
              batch = []
            end
          end

          yield(batch) if batch.any?
        end

        def each_page(column: :iid, page_size: 1_000)
          column = column.to_sym
          column_value = column.to_s.split('__').last.to_sym

          checkpoint = nil

          loop do
            result = self
            result = result.where { Sequel[column] > checkpoint }.offset(nil) if checkpoint

            result = result.
              order(column.asc).
              limit(page_size).
              all.
              compact

            break if result.empty?

            yield result

            break if result.length < page_size

            checkpoint = result.last[column_value]
          end
        end
      end
    end
  end
end
