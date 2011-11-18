if __FILE__ == $0
  $: << File.dirname(__FILE__)
  require File.expand_path('../../config/environment',  __FILE__)
end

require 'scraper'
require 'processor'

class Runner
  def initialize
    @scraper = VilleMontrealQcCa::Scraper.new
    @scraper.processor.register VilleMontrealQcCa::Processor

    @scraper.configure do |c|
      c.log = Logger.new STDOUT # File.expand_path('../../log/scraper.log', __FILE__) # doesn't seem to work on Heroku
      c.datastore = Unbreakable::DataStorage::FileDataStore.new(@scraper, decorators: [:timeout], observers: [:log])
      c.datastore.configure do |d|
        d.root_path = File.expand_path('../../tmp', __FILE__)
        d.store_meta = false
      end

      c.job :pipeline do
      end
    end
  end

  def run(args)
    @scraper.run args
  end
end

if __FILE__ == $0
  Runner.new.run ARGV
end
