module Mosaic
  module Lyris
    class DeliveryDetails < Object
      attr_reader :id,
                  :title,
                  :pub_date,
                  :last_build_date,
                  :items
      def initialize(attributes)
        @items = []
        super(attributes)
      end

      def build_item(title,description)
        items << DeliveryItem.new(title:title,description:description)
      end

    end

    class DeliveryItem < Object
      attr_reader :title,
                  :description
    end

    class QuickMessage < Object
      attr_reader :id,
                  :list_id,
                  :msg_typt,
                  :msg,
                  :msg_sent,
                  :html_mid,
                  :text_mid,
                  :content_analyzer,
                  :inbox_snapshot,
                  :black_list_monitor

    end

    class Message < Object
      attr_reader :id,
                  :aol,
                  :category,
                  :charset,
                  :clickthru,
                  :clickthru_text,
                  :edited_at,
                  :format,
                  :from_email,
                  :from_name,
                  :html,
                  :htmlencoding,
                  :list_id,
                  :name,
                  :list_name,
                  :rule,
                  :segment,
                  :segment_id,
                  :sent,
                  :sent_at,
                  :stats_sent,
                  :subject,
                  :text,
                  :type

      class << self
        def query(what, options = {})
          if what == :all
            query_all(options)
          elsif what == :delivery
            query_delivery(options)
          else
            query_one(what, options)
          end
        end
        # reply = post('record', 'add') do |request|
        #   request.MLID options[:list_id] if options[:list_id]
        #   put_data(request, 'email', email)
        #   put_demographic_data(request, options[:demographics])
        #   put_extra_data(request, 'trigger', 'yes') if options[:trigger]
        #   put_extra_data(request, 'proof', 'yes') if options[:proof]
        #   put_extra_data(request, 'state', options[:state])
        #   put_extra_data(request, 'encoding', options[:encoding])
        #   put_extra_data(request, 'doubleoptin', 'yes') if options[:doubleoptin]
        # end

        def add(options)
          reply = post('message','add') do |request|
            request.MLID options[:list_id] if options[:list_id]
            put_data(request,'name', options[:name]) if options[:name]
            put_data(request,'from-email', options[:from_email])
            put_data(request,'from-name', options[:from_name])
            put_data(request,'message-format', options[:message_format])
            put_data(request,'message-html', options[:message_html])
            put_data(request,'message-text', options[:message_text])
            put_data(request,'subject', options[:subject])
            put_data(request,'attachment', options[:attachment]) if options[:attachment]
            put_data(request,'charset', options[:charset]) if options[:charset]
            put_data(request,'clickthru', options[:clickthru]) if options[:clickthru]
            put_data(request,'clickthru-text', options[:clickthru_text]) if options[:clickthru_text]
            put_data(request,'htmlencoding', options[:htmlencoding]) if options[:htmlencoding]
            put_data(request,'message-AOL', options[:message_aol]) if options[:message_aol]
            put_data(request,'mm_attachment', options[:mm_attachment]) if options[:mm_attachment]
            put_data(request,'category', options[:category]) if options[:category]
          end

          id = reply.search('/DATASET/DATA').inner_html.to_i
          new :id => id,
              :list_id => options[:list_id]

        end

        def copy(mid,options)
          reply = post("message","copy") do |request|
            request.MLID options[:list_id] if options[:list_id]
            request.MID mid
          end
          id = reply.search('/DATASET/DATA').inner_html.to_i
          new :id => id,
              :list_id => options[:list_id]
        end

        def update(mid,options)
          reply = post('message','update') do |request|
            request.MLID options[:list_id] if options[:list_id]
            request.MID mid
            put_data(request,'name', options[:name]) if options[:name]
            put_data(request,'from-email', options[:from_email]) if options[:from_email]
            put_data(request,'from-name', options[:from_name]) if options[:from_name]
            put_data(request,'message-format', options[:message_format]) if options[:message_format]
            put_data(request,'message-html', options[:message_html]) if options[:message_html]
            put_data(request,'message-text', options[:message_text]) if options[:message_text]
            put_data(request,'subject', options[:subject]) if options[:subject]
            put_data(request,'attachment', options[:attachment]) if options[:attachment]
            # char update is not accepting its documented character set options
            # put_data(request,'charset', options[:charset]) if options[:charset]
            put_data(request,'clickthru', options[:clickthru]) if options[:clickthru]
            put_data(request,'clickthru-text', options[:clickthru_text]) if options[:clickthru_text]
            put_data(request,'htmlencoding', options[:htmlencoding]) if options[:htmlencoding]
            put_data(request,'message-AOL', options[:message_aol]) if options[:message_aol]
            put_data(request,'mm_attachment', options[:mm_attachment]) if options[:mm_attachment]
            put_data(request,'category', options[:category]) if options[:category]
          end
          id = reply.search('/DATASET/DATA').inner_html.to_i

          new :id => id,
              :list_id => options[:list_id]

        end

        # Starts/Stops/Pauses messages that are scheduled to be sent out.
        def schedule(mid,options)
          reply = post('message','schedule') do |request|
            request.MLID options[:list_id] if options[:list_id]
            request.MID mid
            put_data(request,'action', options[:action])
            put_data(request,'delivery-year', options[:delivery_year]) if options[:delivery_year]
            put_data(request,'delivery-month', options[:delivery_month]) if options[:delivery_hour]
            put_data(request,'delivery-day', options[:delivery_day]) if options[:delivery_hour]
            put_data(request,'delivery-hour', options[:delivery_hour]) if options[:delivery_hour]
            put_data(request,'rule', options[:rule]) if options[:rule]
            put_data(request,'suppression_list', options[:suppression_list]) if options[:suppression_list]
            put_data(request,'delivery_monitor', options[:delivery_monitor]) if options[:delivery_monitor]
            put_data(request,'black_list_monitor', options[:black_list_monitor]) if options[:black_list_monitor]
            put_data(request,'inbox_snapshot', options[:rule]) if options[:rule]
            put_data(request,'content_analyzer', options[:rule]) if options[:rule]
          end
          msg = reply.search('/DATASET/DATA').inner_html
          return msg
        end

        def message_quicktest(mid,options)
          reply = post('message','message-quicktest') do |request|
            request.MLID options[:list_id] if options[:list_id]
            request.MID mid
            put_extra_data(request, 'EMAILS', options[:emails]) if options[:emails]
            put_extra_data(request, 'content_analyzer', options[:content_analyzer]) if options[:content_analyzer]
            put_extra_data(request, 'inbox_snapshot', options[:inbox_snapshot]) if options[:inbox_snapshot]
            put_extra_data(request, 'black_list_monitor',options[:black_list_monitor]) if options[:black_list_monitor]
            put_extra_data(request, 'multi', options[:multi]) if options[:multi]
          end

          msg = reply.search('/DATASET/DATA').inner_html
          type = reply.search('/DATASET/TYPE').inner_html
          html = reply.search('/DATASET/HTML_MID').inner_html
          text = reply.search('/DATASET/TEXT_MID').inner_html
          c_anlyz = reply.search('/DATASET/CONTENT_ANALYZER').inner_html
          i_snap = reply.search('/DATASET/INBOX_SNAPSHOT').inner_html
          bl_mon = reply.search('/DATASET/BLACK_LIST_MONITOR').inner_html

          QuickMessage.new  :id => mid,
                            :list_id => options[:list_id],
                            :msg_typt => type,
                            :msg => msg,
                            :msg_sent => options[:multi],
                            :html_mid => html,
                            :text_mid => text,
                            :content_analyzer => c_anlyz,
                            :inbox_snapshot => i_snap,
                            :black_list_monitor => bl_mon
        end
      protected
        def query_all(options)
          reply = post('message', 'query-listdata') do |request|
            request.MLID options[:list_id] if options[:list_id]
          end
          reply.search('/DATASET/RECORD').collect do |record|
            edit_time = get_time_data(record, 'last-edit-time')
            edit_date = get_date_data(record, 'last-edit-date')
            sent = get_data(record, 'sent')
            sent_at = get_date_data(record, 'date').to_time + get_time_offset_data(record, 'delivery')
            subject = get_data(record, 'subject')
            new :id => get_integer_data(record, 'mid'),
                :list_id => options[:list_id],
                :category => get_data(record, 'category'),
                :edited_at => edit_date && (edit_date.to_time + edit_time.to_i - edit_time.to_date.to_time.to_i),
                :format => get_data(record, 'message-format'),
                :segment_id => get_integer_data(record, 'segment-id'),
                :segment => get_data(record, 'segment'),
                :name => get_data(record, 'name'),
                :list_name => get_data(record, 'ml-name'),
                :sent => sent,
                :sent_at => sent_at,
                :stats_sent => get_integer_data(record, 'stats-sent'),
                :subject => subject,
                :type => get_data(record, 'mlid').blank? ? 'system' : (subject =~ /\APROOF: / ? 'test' : 'user')
          end
        end

        def query_delivery(options)
          reply = post('message', 'query-deliverydetails') do |request|
            request.MLID options[:list_id] if options[:list_id]
            request.MID options[:m_id]
          end
          channel = reply.at('/rss/channel')
          # items = get_data(channel, 'item')
          delivery = DeliveryDetails.new :id => options[:m_id],
              :title => channel.at('title').inner_html,
              :pub_date => channel.at('pubDate').inner_html,
              :list_id => options[:list_id],
              :last_build_date => channel.at('lastBuildDate').inner_html

          # items.each do |item|
          #   delivery.build_item(get_data(item,"title"),get_data(item,"description"))
          # end if items

          delivery
        end

        def query_one(id, options)
          reply = post('message', 'query-data') do |request|
            request.MLID options[:list_id] if options[:list_id]
            request.MID id
          end
          record = reply.at('/DATASET/RECORD')
          sent = get_data(record, 'sent')
          sent_at = (sent == 'yes' && get_date_data(record, 'date')) ? get_date_data(record, 'date').to_time + get_time_offset_data(record, 'delivery') : nil
          new :id => id,
              :aol => get_data(record, 'message-aol'),
              :list_id => options[:list_id],
              :category => get_data(record, 'category'),
              :charset => get_data(record, 'charset'),
              :clickthru => get_boolean_data(record, 'clickthru', 'on'),
              :clickthru_text => get_boolean_data(record, 'clickthru-text', 'on'),
              :format => get_data(record, 'message-format'),
              :from_email => get_data(record, 'from-email'),
              :from_name => get_data(record, 'from-name'),
              :html => get_data(record, 'message-html'),
              :htmlencoding => get_data(record, 'htmlencoding'),
              :segment_id => get_integer_data(record, 'rule'),
              :segment => get_data(record, 'rule-name'),
              :name => get_data(record, 'name'),
              :list_name => get_data(record, 'ml-name'),
              :sent => sent,
              :sent_at => sent_at,
              :subject => get_data(record, 'subject'),
              :text => get_data(record, 'message-text')
        end
      end

      def sent?
        sent == 'yes'
      end
    end
  end
end
