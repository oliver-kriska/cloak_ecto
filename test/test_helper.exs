ExUnit.configure(formatters: [JUnitFormatter, ExUnit.CLIFormatter])
ExUnit.start()
Cloak.Ecto.TestRepo.start_link()
Cloak.Ecto.TestVault.start_link()
