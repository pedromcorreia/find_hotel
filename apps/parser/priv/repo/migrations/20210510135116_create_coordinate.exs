defmodule Parser.Repo.Migrations.CreateCoordinate do
  use Ecto.Migration

  def change do
    create table(:coordinates) do
      add(:ip_address, :string)
      add(:country_code, :string)
      add(:country, :string)
      add(:city, :string)
      add(:latitude, :float)
      add(:longitude, :float)
      add(:mystery_value, :string)

      timestamps()
    end

    create(index("coordinates", [:ip_address], unique: true))
  end
end
