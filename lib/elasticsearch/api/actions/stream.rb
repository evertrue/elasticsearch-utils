module Elasticsearch
  module API
    module Actions
      # search.stream index: 'scrollindex', scroll: '5m', body: { query: { title: 'test' } }
      #
      # counter = 0
      # search.stream counter, index: 'scrollindex', scroll: '5m', body: { query: { title: 'test' } }

      def stream(*args, &block)
        raise ArgumentError.new "wrong number of arguments (#{args.count} for 1..2)" if args.count > 2
        raise ArgumentError.new 'no block given' unless block_given?

        opts, memo = *args.reverse
        opts[:scroll] = opts[:scroll] || opts['scroll'] || '5m'

        scroll_opts = { :scroll => opts[:scroll] }

        catch :stop_stream do
          results = search opts
          scroll_opts[:body] = results['_scroll_id']

          results = scroll scroll_opts if opts[:search_type] =~ /scan/

          until results['hits']['hits'].empty? do
            scroll_opts[:body] = results['_scroll_id']
            results['hits']['hits'].each do |doc|
              memo = yield doc, memo
            end
            results = scroll scroll_opts
          end
        end

        memo
      end
    end
  end
end
