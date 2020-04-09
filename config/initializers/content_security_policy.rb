# Be sure to restart your server when you modify this file.

# We're using the secure_headers gem to handle our CSP
# https://rubygems.org/gems/secure_headers/versions/6.3.0
# SecureHeaders::Configuration.default
# default config documentation is here:
# https://www.rubydoc.info/gems/secure_headers/6.3.0#Default_values

SecureHeaders::Configuration.default do |config|
  config.cookies = {
    secure: true, # mark all cookies as "Secure"
    httponly: true, # mark all cookies as "HttpOnly"
    samesite: {
      lax: true # mark all cookies as SameSite=lax
    }
  }  # Add "; preload" and submit the site to hstspreload.org for best protection.

  config.hsts = "max-age=#{1.week.to_i}"
  config.x_frame_options = "DENY"
  config.x_content_type_options = "nosniff"
  config.x_xss_protection = "1; mode=block"
  config.x_download_options = "noopen"
  config.x_permitted_cross_domain_policies = "none"
  config.referrer_policy = %w(origin-when-cross-origin strict-origin-when-cross-origin)
  config.csp = {
    # "meta" values. these will shape the header, but the values are not included in the header.
    preserve_schemes: true, # default: false. Schemes are removed from host sources to save bytes and discourage mixed content.
    disable_nonce_backwards_compatibility: true, # default: false. If false, `unsafe-inline` will be added automatically when using nonces. If true, it won't. See #403 for why you'd want this.

    # directive values: these values will directly translate into source directives
    default_src: %w('self'),
    base_uri: %w('self'),
    block_all_mixed_content: true, # see http://www.w3.org/TR/mixed-content/
    child_src: %w('self'), # if child-src isn't supported, the value for frame-src will be set.
    font_src: %w('self' data: https://fonts.gstatic.com),
    form_action: %w('self'),
    frame_ancestors: %w('none'),
    img_src: %w('self' https://*.amazonaws.com), # Whitelist amazonaws to support the Sqreen image
    manifest_src: %w('self'),
    media_src: %w('self'),
    object_src: %w('self'),
    sandbox: false, # true and [] will set a maximally restrictive setting
    script_src: %w('self' 'unsafe-inline'), # unsafe-inline is needed for rails-ujs
    style_src: %w('self' 'unsafe-inline' https://fonts.googleapis.com),
    worker_src: %w('self'),
    upgrade_insecure_requests: Rails.env.production?, # see https://www.w3.org/TR/upgrade-insecure-requests/
  }  # This is available only from 3.5.0; use the `report_only: true` setting for 3.4.1 and below.
end
# Below is the Rails auto-generated CSP config in case
# we want to go back to this from SecureHeaders

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

# Rails.application.config.content_security_policy do |policy|
#   policy.default_src :self, :https
#   policy.font_src    :self, :https, :data
#   policy.img_src     :self, :https, :data
#   policy.object_src  :none
#   policy.script_src  :self, :https
#   policy.style_src   :self, :https, :unsafe_inline
#   # If you are using webpack-dev-server then specify webpack-dev-server host
#   policy.connect_src :self, :https, "http://localhost:3035", "ws://localhost:3035" if Rails.env.development?

#   # Specify URI for violation reports
#   # policy.report_uri "/csp-violation-report-endpoint"
# end

# # If you are using UJS then enable automatic nonce generation
# Rails.application.config.content_security_policy_nonce_generator = -> request { SecureRandom.base64(16) }

# # Set the nonce only to specific directives
# Rails.application.config.content_security_policy_nonce_directives = %w(script-src style-src)

# # Report CSP violations to a specified URI
# # For further information see the following documentation:
# # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
# Rails.application.config.content_security_policy_report_only = false
