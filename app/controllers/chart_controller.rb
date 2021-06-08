class ChartController < ApplicationController
  def index
  end

  def show
    @clients = User.where(:role => 'client')
    @freelancers = User.where(:role => 'freelancer')

    @per_client_tasks = User.select('users.name, count(jobs.id)')
                            .from('users').where('role = "client"')
                            .joins('LEFT JOIN jobs ON users.id = jobs.user_id')
                            .group('jobs.user_id')
                            .order('count(jobs.id) DESC')

    @per_freelancer_bid_tasks = User.select('users.name , IFNULL(_bids.bids, 0) as "_bids" , ifnull("_hired".bids,0) as hired')
                                    .from('users').where('role = "freelancer"')
                                    .joins('LEFT JOIN (SELECT users.name, count(hires.id) as bids FROM users LEFT JOIN hires ON users.id = hires.user_id GROUP BY hires.user_id) as _bids ON _bids.name = users.name')
                                    .joins('LEFT JOIN (SELECT users.name, count(1) as bids FROM users LEFT JOIN hires ON users.id = hires.user_id WHERE hires.state_id = 3 GROUP BY hires.user_id) as _hired ON "_hired".name = users.name')
                                    .order('"_bids" DESC')

    @per_category_tasks = Category.select('categories.category_name, count(jobs.id)')
                              .from('categories')
                              .joins('LEFT JOIN jobs ON categories.id = jobs.category_id')
                              .group('jobs.category_id')
                              .order('count(jobs.id) DESC')
    # @per_date_tasks = Job.group(:reg_date).count(:id)
  end
end
