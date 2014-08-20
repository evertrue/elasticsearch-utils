module Elasticsearch
  module API
    module Actions
    	def stream(arguments = {})
    		raise ArgumentError.new "wrong number of arguments (#{memo_args.count} for 0..1)" if memo_args.count > 1
    		raise ArgumentError.new 'no block given' unless block_given?

    		results = client.search opts.reverse_merge index: primary_index, scroll: scroll

		    scroll_opts = { scroll_id: results['_scroll_id'], scroll: scroll }

    		memo = memo_args.first

    		catch(:stop_stream) do
      		until results['hits']['hits'].empty? do
        		results['hits']['hits'].each do |doc|
          	doc_source = doc['_source']
          	memo = yield doc_source, memo
        	end

        	results = client.scroll scroll_opts
      	end
      	
      	memo
    	end
    end
  end
end