module Mosaic
  module Lyris
    class Template < Object

      attr_reader :name,
                  :id,
                  :url

      class << self
        def query(options={})
          reply = post("message","query-templates") do |request|
            request.MLID options[:list_id] if options[:list_id]
            put_extra_data(request, 'TYPE', 'COUNT')
            put_extra_data(request, 'QUERY_TYPE', 'GLOBAL')
          end
          reply.search('/DATASET/TEMPLATE').collect do |template|
            new :id => template.search('ID'),
                :name => template.search('NAME'),
                :url => template.search('URL')
          end
        end
      end

    end
  end
end

