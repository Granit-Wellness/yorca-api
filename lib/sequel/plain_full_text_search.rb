# frozen_string_literal: true

module Sequel
  module Plugins
    module PlainFullText
      module DatasetMethods
        def plain_full_text_search(cols, terms)
          lang    = Sequel.cast('simple', :regconfig)
          columns = full_text_string_join(cols)
          vector  = Sequel.function(:to_tsvector, lang, columns)

          queries = Array(terms).map do |term|
            Sequel.function(:plainto_tsquery, lang, term)
          end

          query = Sequel.join(queries)

          where(Sequel.lit(['(', ' @@ ', ')'], vector, query))
        end
      end
    end
  end
end
