require 'active_record'
require 'sqlite3'
require 'logger'

require 'new_relic/agent'
NewRelic::Agent.manual_start(:sync_startup => true)

ActiveRecord::Base.logger = Logger.new('debug.log')
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'products.sqlite3')

class Product < ActiveRecord::Base
	include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation
	def create
	end
	add_transaction_tracer :create, :category => :task
end

tv = Product.new(:name => 'tv').create
shoe = Product.new(:name => 'shoe')

data = Product.all

::NewRelic::Agent.shutdown

