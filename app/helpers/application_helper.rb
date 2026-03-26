module ApplicationHelper
  # [HW] format_caption: renders a photo caption with hashtags styled in blue.
  # CSS alone cannot target words that start with # — something has to wrap them
  # in an HTML element first. This helper does that on the server side (safer than
  # doing it in JavaScript, because it avoids putting user text into innerHTML).
  # Step 1: html_escape the raw text to prevent XSS (e.g. if a caption contained <script>).
  # Step 2: wrap every #word in a <span class="caption-hashtag"> so CSS can colour it.
  # Step 3: mark the result html_safe so Rails outputs the spans instead of escaping them.
  def format_caption(text)
    return "" if text.blank?
    safe = ERB::Util.html_escape(text)
    safe.gsub(/#(\w+)/, '<span class="caption-hashtag">#\1</span>').html_safe
  end

  # [MG] Maps a task status string to one of three badge modifier classes:
  # open (grey), in-progress (yellow), or done (green).
  # Only "not started" is open; a fixed set of strings are in-progress;
  # anything else (including date placeholders like "[Departure Date]") is treated as done.
  IN_PROGRESS_STATUSES = %w[sent in\ progress pending ongoing\ coordination].freeze

  def task_badge_label(status)
    return "open"        if status.blank? || status == "not started"
    return "in progress" if IN_PROGRESS_STATUSES.include?(status.downcase)
    "done"
  end

  def task_badge_class(status)
    return "task-table__badge--open"        if status.blank? || status == "not started"
    return "task-table__badge--in-progress" if IN_PROGRESS_STATUSES.include?(status.downcase)
    "task-table__badge--done"
  end
end
