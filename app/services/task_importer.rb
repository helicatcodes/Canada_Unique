require "roo"
require "open-uri"

class TaskImporter
  def call
    spreadsheet = fetch_spreadsheet
    spreadsheet.each_row_streaming(offset: 1, pad_cells: true) do |row|
      email = row[0]&.value&.gsub(/<[^>]*>/, "")&.strip
      task_name   = row[1]&.value
      description = row[2]&.value
      status      = row[3]&.value
      obligatory = row[4]&.value


      next if email.blank? || task_name.blank?

      user = User.find_by(email: email)
      next if user.nil?

      task = user.tasks.find_or_initialize_by(name: task_name)
      task.description = description
      task.status      = status
      task.obligatory = obligatory
      task.save!
    end
  end

  private

  def fetch_spreadsheet
    file = URI.open(ENV["TASK_EXCEL_URL"])
    spreadsheet = Roo::Spreadsheet.open(file, extension: :xlsx)
    spreadsheet.sheet("App_test")
  end
end
