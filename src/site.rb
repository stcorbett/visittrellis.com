# Facts the pages share. Change them here, not in the templates.
module Site
  NAME          = "Trellis"
  URL           = "https://visittrellis.com"
  APP           = "https://app.visittrellis.com"
  SIGN_UP       = "#{APP}/registration/new" # then "Name your community" (organizations/new)
  SIGN_IN       = "#{APP}/session/new"
  # Needs a mailbox or forwarding before launch: the apex has no MX today
  # (mail is sent from mail.visittrellis.com). See docs/DEPLOY.md.
  CONTACT_EMAIL = "hello@visittrellis.com"
  COMPANY       = "Crafty Machine LLC"
  COMPANY_URL   = "https://craftymachine.com"
  # The date the terms and privacy policy last changed in substance.
  POLICIES_UPDATED = "November 20, 2026"
end
