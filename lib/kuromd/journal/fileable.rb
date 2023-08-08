# frozen_string_literal: true

module Kuromd
  module Journal
    # defines the functions for managing files and folders for journals
    module Fileable
      def create_journal_folder(date:)
        full_date_path = build_date_path(date:)
        Kuromd.logger.info "Creating folder for #{full_date_path}"
        FileUtils.mkdir_p full_date_path
      end

      private

      def build_date_path(base_path:, date:)
        Kuromd.logger.info "Creating date path for #{date}"
        working_date  = date

        padded_year   = working_date.year.to_s
        padded_month  = working_date.month.to_s.rjust(2, '0')
        padded_day    = working_date.mday.to_s.rjust(2, '0')

        day_folder    = "#{padded_day} #{Date::ABBR_DAYNAMES[working_date.wday]}"
        folder_path   = File.join(base_path, padded_year, padded_month, day_folder)

        File.expand_path(folder_path)
      end
    end
  end
end
