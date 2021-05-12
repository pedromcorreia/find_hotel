import Config

# 5 minutes in seconds
config :parser,
  schedule_job_time: 300

import_config "#{Mix.env()}.exs"
