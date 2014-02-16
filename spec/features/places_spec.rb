require 'spec_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    BeermappingApi.stub(:places_in).with("kumpula").and_return(
        [ Place.new(name: "Oljenkorsi", city:"kumpula", id: 1) ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if many returned by API, all are shown at the page" do
    BeermappingApi.stub(:places_in).with("kumpula").and_return(
        [ Place.new(name:"Oljenkorsi1", city:"kumpula", id:1 ),  Place.new(name:"Oljenkorsi2", city:"kumpula", id:2)]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi1"
    expect(page).to have_content "Oljenkorsi2"
  end

  it "nothing returned, nothing shown" do
    BeermappingApi.stub(:places_in).with("kumpula").and_return(
        [ ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "No locations in kumpula"
  end

end