import { Controller } from "@hotwired/stimulus"

// [HW] Stimulus controller that powers the location autocomplete in the Add Photo modal.
// [HW] Queries the free Nominatim (OpenStreetMap) API, restricted to Canada only.
// [HW] Formats each result to show just the place/business name + city — no county/province/country.
export default class extends Controller {
  static targets = ["input", "dropdown"]

  // [HW] Store a reference for the debounce timer so we can cancel it on each new keystroke
  connect() { this.debounceTimer = null }

  // [HW] Called on every keystroke — waits 300ms after the user stops typing before fetching
  search() {
    clearTimeout(this.debounceTimer)
    const query = this.inputTarget.value.trim()
    if (query.length < 3) { this.clearDropdown(); return }
    this.debounceTimer = setTimeout(() => this.fetchSuggestions(query), 300)
  }

  // [HW] Hits Nominatim with countrycodes=ca (Canada only) and addressdetails=1
  // [HW] so the structured address object is available for clean formatting
  async fetchSuggestions(query) {
    const url = `https://nominatim.openstreetmap.org/search?q=${encodeURIComponent(query)}&format=json&limit=5&countrycodes=ca&addressdetails=1`
    const res = await fetch(url, { headers: { "Accept-Language": "en" } })
    this.renderDropdown(await res.json())
  }

  // [HW] Builds a short human-readable label from a Nominatim result.
  // [HW] For a POI/business: "Tim Hortons, Toronto"
  // [HW] For a city/area: "Toronto"
  // [HW] Fallback: first segment of display_name (before the first comma)
  formatResult(r) {
    const addr = r.address || {}
    const city = addr.city || addr.town || addr.village || addr.municipality || ""
    const name = r.name || ""

    // [HW] Only prepend the name if it's meaningfully different from the city itself
    if (name && name !== city) {
      return city ? `${name}, ${city}` : name
    }
    return city || r.display_name.split(",")[0].trim()
  }

  // [HW] Renders a button per result using the short formatted label
  renderDropdown(results) {
    this.dropdownTarget.innerHTML = ""
    if (!results.length) { this.dropdownTarget.hidden = true; return }

    results.forEach(r => {
      const label = this.formatResult(r)
      const btn = document.createElement("button")
      btn.type = "button"
      btn.className = "location-suggestion"
      btn.textContent = label
      // [HW] Store the short label in the input (not the full display_name)
      btn.addEventListener("click", () => this.select(label))
      this.dropdownTarget.appendChild(btn)
    })

    this.dropdownTarget.hidden = false
  }

  // [HW] Fills the input with the chosen short label and closes the dropdown
  select(name) { this.inputTarget.value = name; this.clearDropdown() }

  // [HW] Empties and hides the dropdown
  clearDropdown() { this.dropdownTarget.innerHTML = ""; this.dropdownTarget.hidden = true }
}
