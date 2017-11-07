class CreateJoinTableCampaignQuestion < ActiveRecord::Migration[5.1]
  def change
    create_join_table :campaigns, :questions do |t|
       t.index [:campaign_id, :question_id]
       t.index [:question_id, :campaign_id]
    end
  end
end
