class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :image,
                        :inventory
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: 0
  validates_numericality_of :inventory, greater_than_or_equal_to: 0


  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def activate
    update(active?: true)
  end

  def deactivate
    update(active?: false)
  end

  def self.most_popular(num_items_to_show)
    Item.joins(:item_orders)
        .select('items.*, sum(item_orders.quantity)')
        .group(:id)
        .order("sum(item_orders.quantity) DESC")
        .limit(num_items_to_show)
  end

  def self.least_popular(num_items_to_show)
    Item.joins(:item_orders)
        .select('items.*, sum(item_orders.quantity)')
        .group(:id)
        .order("sum(item_orders.quantity) ASC")
        .limit(num_items_to_show)
  end

  def deletable?
    !orders.any?
  end

end
