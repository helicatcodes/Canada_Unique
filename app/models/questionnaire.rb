class Questionnaire < ApplicationRecord
  belongs_to :user
  has_many :questions
  has_many :answers, through: :questions

  # [HW] The 8 fixed reflection questions shown to every student.
  # Stored here so create_for and seeds both use the same source of truth.
  QUESTIONS = [
    "What was the most significant challenge you faced during your exchange year, and how did you overcome it?",
    "How has living in Canada changed the way you see your home country and culture?",
    "Describe a moment when you stepped far outside your comfort zone. What did you learn about yourself?",
    "How has your confidence in English (or French) changed since the beginning of your exchange?",
    "In what ways do you feel more independent compared to when you first arrived in Canada?",
    "How did you handle feelings of homesickness or culture shock? What coping strategies worked for you?",
    "How have your goals and ambitions for the future changed as a result of your exchange experience?",
    "If you could give advice to a student about to start their exchange year in Canada, what would you tell them?"
  ].freeze

  # [HW] Factory method: creates a questionnaire for the given user and seeds it
  # with one Question record per entry in QUESTIONS. Called by the controller
  # on first visit to /post_canada and by seeds.rb.
  def self.create_for(user)
    questionnaire = create!(user: user)
    QUESTIONS.each { |text| questionnaire.questions.create!(text: text) }
    questionnaire
  end
end
