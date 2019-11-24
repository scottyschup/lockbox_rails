module StyleHelper
  def computed_style(selector:, prop:)
    pseudo = nil

    if selector.include?(":")
      selector, pseudo = selector.split(":")
    end

    page.evaluate_script(
      "window.getComputedStyle(document.querySelector('#{selector}'), '#{pseudo}').getPropertyValue('#{prop}')"
    )
  end
end
