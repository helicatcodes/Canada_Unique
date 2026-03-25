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
end
