module Mosaic
  module Lyris
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
                  :name,
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
          else
            query_one(what, options)
          end
        end

        def send_mail(id, *recipients)
          options = recipients.pop if recipients.last.is_a?(Hash)
          list_id = options[:list_id] || default_list_id
          reply = post('message', 'add') do |request|
            request.MLID list_id if list_id
            put_data(request, 'subject', options[:subject])
            put_data(request, 'message-html', options[:message]) 
            put_data(request, 'clickthru', 'on')  
            put_data(request, 'from_email', options[:from_email])
            put_data(request, 'from_name', options[:from_name])
            put_data(request, 'charset', 'UTF-8')
            put_data(request, 'message-format', 'HTML')
          end
          if reply =~ /<TYPE>error<\/TYPE><DATA>(.+?)<\/DATA>/
            return false
          elsif reply =~ /<TYPE>success<\/TYPE><DATA>(.+?)<\/DATA>/
            #send_message($~[1], options.to_h) 
            trigger = Mosaic::Lyris::Trigger.fire(*args)
          end
        end
        

      protected
        def send_message(message_id, *recipients)
          options = recipients.pop if recipients.last.is_a?(Hash)
          list_id = options[:list_id] || default_list_id
          reply = post('message', 'message-quicktest') do |request|
            request.MLID list_id if list_id
            request.MID message_id 
            put_extra_data(request, 'emails', options[:emails].join(","))
          end
        end

        def query_all(options)
          reply = post('message', 'query-listdata') do |request|
            request.MLID options[:list_id] if options[:list_id]
          end
          reply.search('/DATASET/RECORD').collect do |record|
            edit_time = get_time_data(record, 'last-edit-time')
            edit_date = get_date_data(record, 'last-edit-date')
            sent = get_data(record, 'sent')
            sent_at = (sent == 'yes') ? get_date_data(record, 'date').to_time + get_time_offset_data(record, 'delivery') : nil
            subject = get_data(record, 'subject')
            new :id => get_integer_data(record, 'mid'),
                :category => get_data(record, 'category'),
                :edited_at => edit_date && (edit_date.to_time + edit_time.to_i - edit_time.to_date.to_time.to_i),
                :format => get_data(record, 'message-format'),
                :segment_id => get_integer_data(record, 'segment-id'),
                :segment => get_data(record, 'segment'),
                :sent => sent,
                :sent_at => sent_at,
                :stats_sent => get_integer_data(record, 'stats-sent'),
                :subject => subject,
                :type => get_data(record, 'mlid').blank? ? 'system' : (subject =~ /\APROOF: / ? 'test' : 'user')
          end
        end

        def query_one(id, options)
          reply = post('message', 'query-data') do |request|
            request.MLID options[:list_id] if options[:list_id]
            request.MID id
          end
          record = reply.at('/DATASET/RECORD')
          sent = get_data(record, 'sent')
          sent_at = (sent == 'yes') ? get_date_data(record, 'date').to_time + get_time_offset_data(record, 'delivery') : nil
          new :id => id,
              :aol => get_data(record, 'message-aol'),
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
