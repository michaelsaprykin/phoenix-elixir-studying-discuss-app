defmodule Discuss.User do
  use Discuss.Web, :model


  schema "users" do
    field :email, :string
    field :provider, :string
    field :token, :string
    field :avatar_url, :string
    has_many :topics, Discuss.Topic

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :provider, :token, :avatar_url])
    |> validate_required([:email, :provider, :token])
  end
end
