class Product < ActiveRecord::Base
  attr_accessible :name, :price, :index_attributes
  has_one :index, :as => :owner, :dependent => :destroy

  accepts_nested_attributes_for :index, :allow_destroy => true

  include ActsAsPrioritizable
#  acts_as_prioritizable("index", "assets")

  before_create do
    build_index({:name => name}) unless index
  end

  def title
    name.downcase.gsub(" ", "_")
  end
end
