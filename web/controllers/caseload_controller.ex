defmodule Healthlocker.CaseloadController do
  use Healthlocker.Web, :controller

  alias Healthlocker.{EPJSTeamMember, EPJSUser, EPJSPatientAddressDetails,
                      EPJSClinician, ReadOnlyRepo, User}

  def index(conn, _params) do
    clinician = if conn.assigns.current_user.email == "robert_macmurray@nhs.co.uk" do
                  ReadOnlyRepo.one(from c in EPJSClinician,
                              where: c."GP_Code" == "NyNsn50mPQPFZYn7")
                else
                  ReadOnlyRepo.one(from c in EPJSClinician,
                              where: c."GP_Code" == "yr68Dobil7yD40Ag")
                end

    patient_ids = EPJSTeamMember
                  |> EPJSTeamMember.patient_ids(clinician.id)
                  |> ReadOnlyRepo.all

    hl_users = patient_ids
              |> Enum.map(fn x ->
                Repo.all(from u in User,
                where: u.slam_id == ^x,
                preload: [:carers])
              end)
              |> Enum.concat

    non_hl = patient_ids
              |> Enum.map(fn x ->
                ReadOnlyRepo.all(from e in EPJSUser,
                where: e."Patient_ID" == ^x)
              end)
              |> Enum.concat
              |> Enum.reject(fn x ->
                Enum.any?(hl_users, fn x2 ->
                  x."Patient_ID" == x2.slam_id
                end)
              end)
    render(conn, "index.html", hl_users: hl_users, non_hl: non_hl)
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    slam_user = ReadOnlyRepo.one(from e in EPJSUser,
                where: e."Patient_ID" == ^user.slam_id)
    address = ReadOnlyRepo.one(from e in EPJSPatientAddressDetails,
                    where: e."Patient_ID" == ^user.slam_id)
    render(conn, "show.html", user: user, slam_user: slam_user, address: address)
  end
end
