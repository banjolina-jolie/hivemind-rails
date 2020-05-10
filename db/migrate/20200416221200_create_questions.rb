class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions, id: :uuid do |t|
      t.uuid :user_id
      t.timestamps null: false
      t.string :question_text
      t.string :answer
      t.string :job_id
      t.datetime :start_time
      t.datetime :voting_round_end_time
      t.datetime :end_time
      t.integer :voting_interval, null: false, default: 30
    end

    add_index :questions, :user_id
  end
end
