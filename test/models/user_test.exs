defmodule Healthlocker.UserTest do
  use Healthlocker.ModelCase

  alias Healthlocker.User

  @step1_attrs %{
    email: "me@example.com",
    name: "MyName"
  }
  @step2_attrs %{password: "abc123",
   password_confirmation: "abc123",
   security_answer: "B658H",
   security_question: "4"}
  @step3_attrs %{
    terms_conditions: true,
    privacy: true,
    data_access: true
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @step1_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "security_question changeset with valid attributes" do
    changeset = User.security_question(%User{}, @step2_attrs)
    assert changeset.valid?
  end

  test "security_question changeset with invalid attributes" do
    changeset = User.security_question(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "data_access changeset with valid attributes" do
    changeset = User.data_access(%User{}, @step3_attrs)
    assert changeset.valid?
  end

  test "data_access changeset with invalid attributes" do
    changeset = User.data_access(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "registration_changeset with valid attributes" do
    changeset = User.registration_changeset(%User{}, @step2_attrs)
    assert changeset.valid?
  end

  test "registration_changeset with invalid attributes" do
    changeset = User.registration_changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "put_pass_hash sets password_hash with valid changeset" do
    changeset = User.registration_changeset(%User{}, @step2_attrs)
    assert get_field(changeset, :password_hash)
  end
end