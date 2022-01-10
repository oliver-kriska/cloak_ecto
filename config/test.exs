import Config

config :cloak_ecto, Cloak.Ecto.TestVault,
  json_library: Jason,
  ciphers: [
    default:
      {Cloak.Ciphers.AES.GCM,
       tag: "AES.GCM.V1", key: Base.decode64!("3Jnb0hZiHIzHTOih7t2cTEPEpY98Tu1wvQkPfq/XwqE=")},
    secondary:
      {Cloak.Ciphers.AES.CTR,
       tag: "AES.CTR.V1", key: Base.decode64!("o5IzV8xlunc0m0/8HNHzh+3MCBBvYZa0mv4CsZic5qI=")}
  ]

config :logger, level: :warn

config :cloak_ecto, ecto_repos: [Cloak.Ecto.TestRepo]

config :junit_formatter,
  report_dir: "/tmp/test-results",
  automatic_create_dir?: true,
  # Save output to "/tmp/junit.xml"
  report_file: "junit.xml",
  # Adds information about file location when suite finishes
  print_report_file: true,
  # Include filename and file number
  include_filename?: true,
  include_file_line?: true,
  prepend_project_name?: true
