class CreateProductReports < ActiveRecord::Migration[5.0]
  def up
    create_table :product_reports do |t|
	    t.string :report, limit: 5000
	    t.belongs_to :product, index: true
      t.timestamps
    end
  end

  def down
  	drop_table :product_reports
  end
end

