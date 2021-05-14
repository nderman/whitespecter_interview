# frozen_string_literal: true
require 'rails_helper'
require 'json'

RSpec.describe('Group Events API', type: :request) do
  # initialize test data
  let!(:group_events) { create_list(:group_event, 10) }
  let(:group_event_id) { group_events.first.id }

  # Test suite for GET /group_events
  describe 'GET /group_events' do
    # make HTTP get request before each example
    before { get '/group_events' }

    it 'returns group_events' do
      expect(JSON.parse(response.body)).not_to(be_empty)
      expect(JSON.parse(response.body).size).to(eq(10))
    end

    it 'returns status code 200' do
      expect(response).to(have_http_status(200))
    end
  end

  describe 'GET /group_events/:id' do
    before { get "/group_events/#{group_event_id}" }

    context 'when the record exists' do
      it 'returns the group_event' do
        expect(JSON.parse(response.body)).not_to(be_empty)
        expect(JSON.parse(response.body)['id']).to(eq(group_event_id))
      end

      it 'returns status code 200' do
        expect(response).to(have_http_status(200))
      end
    end

    context 'when the record does not exist' do
      let(:group_event_id) { 100 }

      it 'returns status code 404' do
        expect(response).to(have_http_status(404))
      end

      it 'returns a not found message' do
        expect(response.body).to(match(/Not found/))
      end
    end
  end

  describe 'POST /group_events' do
    # valid payload
    let(:valid_attributes) do
      { start_date: Date.new(2020, 10, 1),
        end_date: Date.new(2020, 10, 21),
        duration: 20,
        name: "some name",
        description: "<p> some text </p>",
        deleted: false,
        published: true,
        location: "some place" }
    end
    let(:attributes) do
      { start_date: Date.new(2020, 10, 11),
        end_date: Date.new(2020, 10, 21),
        duration: 10,
        name: "some name",
        description: "<p> some text </p>",
        deleted: false,
        published: true,
        location: "some place" }
    end

    context 'when the request is valid' do
      before { post '/group_events', params: valid_attributes }

      it 'creates a group_event' do
        expect(JSON.parse(response.body)['name']).to(eq('some name'))
      end

      it 'calculates a duration if start and end ate are given' do
        expect(JSON.parse(response.body)['name']).to(eq('some name'))
      end

      it 'returns status code 201' do
        expect(response).to(have_http_status(201))
      end
    end

    context 'Calculation of missing date or duration' do
      it 'calculates a duration if start and end date are given' do
        valid_attributes = attributes
        valid_attributes.delete(:duration)
        post '/group_events', params: valid_attributes
        expect(JSON.parse(response.body)['duration']).to(eq(10))
      end
      it 'calculates a start if end and duration are given' do
        valid_attributes = attributes
        valid_attributes.delete(:start_date)
        post '/group_events', params: valid_attributes
        expect(JSON.parse(response.body)['start_date']).to(eq("2020-10-11"))
      end
      it 'calculates a start if end and duration are given' do
        valid_attributes = attributes
        valid_attributes.delete(:end_date)
        post '/group_events', params: valid_attributes
        expect(JSON.parse(response.body)['end_date']).to(eq("2020-10-21"))
      end
    end

    context 'Fails when publishing without all fields set' do
      it 'returns status code 422' do
        valid_attributes = attributes
        valid_attributes.delete(:description)
        post '/group_events', params: valid_attributes
        expect(response).to(have_http_status(422))
      end
      it 'returns a validation failure message' do
        valid_attributes = attributes
        valid_attributes.delete(:description)
        post '/group_events', params: valid_attributes
        expect(response.body)
          .to(match("Cannot save without all fields"))
      end
    end

    context 'when the request is invalid - end before start' do
      it 'returns status code 422' do
        invalid_attributes = attributes
        invalid_attributes[:end_date] = Date.new(2020, 10, 1)
        post '/group_events', params: invalid_attributes
        expect(response).to(have_http_status(422))
      end

      it 'returns a validation failure message' do
        invalid_attributes = attributes
        invalid_attributes[:end_date] = Date.new(2020, 10, 1)
        post '/group_events', params: invalid_attributes
        expect(response.body)
          .to(match("Start date must be before end"))
      end
    end
    context 'when the request is invalid - duration and dates not matching' do
      before { post '/group_events', params: attributes }

      it 'returns status code 422' do
        invalid_attributes = attributes
        invalid_attributes[:duration] = 50
        post '/group_events', params: invalid_attributes
        expect(response).to(have_http_status(422))
      end

      it 'returns a validation failure message' do
        invalid_attributes = attributes
        invalid_attributes[:duration] = 50
        post '/group_events', params: invalid_attributes
        expect(response.body)
          .to(match("Dates do not match duration"))
      end
    end
  end

  describe 'PUT /group_events/:id' do
    let(:valid_attributes) { { description: 'new description' } }

    context 'when the record exists' do
      before { put "/group_events/#{group_event_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to(be_empty)
      end

      it 'returns status code 204' do
        expect(response).to(have_http_status(204))
      end
    end
  end

  describe 'DELETE /group_events/:id' do
    before { delete "/group_events/#{group_event_id}" }

    it 'returns status code 204' do
      expect(response).to(have_http_status(204))
    end
  end
end
