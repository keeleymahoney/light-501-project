require 'rails_helper'

RSpec.describe "Forms Feature", type: :feature do
	describe 'Sunny Day' do
		before do
			# Responses expected when successfully creating a form
			stub_request(:post, 'https://forms.googleapis.com/v1/forms').to_return(status: 200, body:
			{
				"formId": "TEST_ID",
				"responderUri": "https://docs.google.com/forms/d/e/VIEW_ID/viewform",
			}.to_json,
			headers: { 'Content-Type' => 'application/json' }
			)
			stub_request(:post, 'https://forms.googleapis.com/v1/forms/TEST_ID:batchUpdate').to_return(status: 200, body: "TEST_BODY")
			stub_request(:patch, 'https://www.googleapis.com/drive/v3/files/TEST_ID').to_return(status: 200)

			# Responses expected when successfully showing an existing form
			stub_request(:get, 'https://forms.googleapis.com/v1/forms/TEST_ID/responses').to_return(status: 200, body: {
				"responses": []
			}.to_json,
			headers: { 'Content-Type' => 'application/json' }
			)
			stub_request(:get, 'https://forms.googleapis.com/v1/forms/TEST_ID').to_return(status: 200, body: {
				"responderUri": "https://docs.google.com/forms/d/e/VIEW_ID/viewform"
			}.to_json,
			headers: { 'Content-Type' => 'application/json' })

			# Responses expected when successfully destroying a form
			stub_request(:delete, 'https://www.googleapis.com/drive/v3/files/TEST_ID').to_return(status: 200)

			# Successfully logged in member with token that hasn't expired
			OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
				provider: 'google_oauth2',
				uid: '123545',
				info: {
				  email: 'testuser@tamu.edu',
				  name: 'Test User'
				},
				credentials: {
				  token: '123456789abc',
				  expires_at: 999999999999999
				}
			  })				

			@event = Event.create(name: 'Party', date: DateTime.now, description: "The good party", location: "My house")   
		end

		context 'Create Forms' do
			scenario 'RSVP Form' do
				visit root_path
				
				click_button 'Login with Google'

				visit events_path

				click_on 'RSVP Form'

				expect(current_path).to eq(show_rsvp_form_event_path(@event))

				expect(page).not_to have_content('RSVP Form for Party')
				expect(page).not_to have_content('Responses')
				expect(page).not_to have_link('Submission Form') 
				expect(page).not_to have_link('Edit In Google Forms')
				expect(page).not_to have_link('Delete Form')
				expect(page).to have_content('Form Does Not Exist')	
				expect(page).to have_link('Create Form', href: create_rsvp_form_event_path(@event))			

				click_on 'Create Form'

				expect(current_path).to eq(show_rsvp_form_event_path(@event))

				expect(page).not_to have_content('Form Does Not Exist')
				expect(page).not_to have_link('Create Form')
				expect(page).to have_content('RSVP Form for Party')
				expect(page).to have_content('Responses: 0')
				expect(page).to have_link('Submission Form', href: 'https://docs.google.com/forms/d/e/VIEW_ID/viewform')
				expect(page).to have_link('Edit In Google Forms', href: 'https://docs.google.com/forms/d/TEST_ID/edit')
				expect(page).to have_link('Delete Form', href: delete_rsvp_form_event_path(@event))
				expect(page).to have_content('RSVP form successfully created.')
			end

			scenario 'Feedback Form' do
				visit root_path
				
				click_button 'Login with Google'

				visit events_path

				click_on 'Feedback Form'

				expect(current_path).to eq(show_feedback_form_event_path(@event))

				expect(page).not_to have_content('Feedback Form for Party')
				expect(page).not_to have_content('Responses')
				expect(page).not_to have_link('Submission Form') 
				expect(page).not_to have_link('Edit In Google Forms')
				expect(page).not_to have_link('Delete Form')
				expect(page).to have_content('Form Does Not Exist')	
				expect(page).to have_link('Create Form', href: create_feedback_form_event_path(@event))			

				click_on 'Create Form'

				expect(current_path).to eq(show_feedback_form_event_path(@event))

				expect(page).not_to have_content('Form Does Not Exist')
				expect(page).not_to have_link('Create Form')
				expect(page).to have_content('Feedback Form for Party')
				expect(page).to have_content('Responses: 0')
				expect(page).to have_link('Submission Form', href: 'https://docs.google.com/forms/d/e/VIEW_ID/viewform')
				expect(page).to have_link('Edit In Google Forms', href: 'https://docs.google.com/forms/d/TEST_ID/edit')
				expect(page).to have_link('Delete Form', href: delete_feedback_form_event_path(@event))
				expect(page).to have_content('Feedback form successfully created.')
			end
		end  

		context 'Destroy Forms' do
			scenario 'RSVP Form' do
				visit root_path
				
				click_button 'Login with Google'

				visit events_path

				click_on 'RSVP Form'

				expect(current_path).to eq(show_rsvp_form_event_path(@event))

				click_on 'Create Form'

				expect(current_path).to eq(show_rsvp_form_event_path(@event))

				click_on 'Delete Form'

				expect(current_path).to eq(delete_rsvp_form_event_path(@event))

				expect(page).to have_link('Back to RSVP Form', href: show_rsvp_form_event_path(@event))
				expect(page).to have_content('Are you sure you want to permanently delete this RSVP form?')
				expect(page).to have_content("RSVP Form's Event Name:\nParty")
				expect(page).to have_button('Delete RSVP Form')

				click_button 'Delete RSVP Form'

				expect(current_path).to eq(show_rsvp_form_event_path(@event))

				expect(page).not_to have_content('RSVP Form for Party')
				expect(page).not_to have_content('Responses')
				expect(page).not_to have_link('Submission Form') 
				expect(page).not_to have_link('Edit In Google Forms')
				expect(page).not_to have_link('Delete Form')
				expect(page).to have_content('Form Does Not Exist')	
				expect(page).to have_link('Create Form', href: create_rsvp_form_event_path(@event))
				expect(page).to have_content('RSVP form was successfully destroyed.')
			end

			scenario 'Feedback Form' do
				visit root_path
				
				click_button 'Login with Google'

				visit events_path

				click_on 'Feedback Form'

				expect(current_path).to eq(show_feedback_form_event_path(@event))

				click_on 'Create Form'

				expect(current_path).to eq(show_feedback_form_event_path(@event))

				click_on 'Delete Form'

				expect(current_path).to eq(delete_feedback_form_event_path(@event))

				expect(page).to have_link('Back to Feedback Form', href: show_feedback_form_event_path(@event))
				expect(page).to have_content('Are you sure you want to permanently delete this feedback form?')
				expect(page).to have_content("Feedback Form's Event Name:\nParty")
				expect(page).to have_button('Delete Feedback Form')

				click_button 'Delete Feedback Form'

				expect(current_path).to eq(show_feedback_form_event_path(@event))

				expect(page).not_to have_content('Feedback Form for Party')
				expect(page).not_to have_content('Responses')
				expect(page).not_to have_link('Submission Form') 
				expect(page).not_to have_link('Edit In Google Forms')
				expect(page).not_to have_link('Delete Form')
				expect(page).to have_content('Form Does Not Exist')	
				expect(page).to have_link('Create Form', href: create_feedback_form_event_path(@event))
				expect(page).to have_content('Feedback form was successfully destroyed.')
			end
		end  
	end

	describe 'Rainy Day (API Down)' do
		before do
			# Responses expected when trying to create a form and the API is down
			stub_request(:post, 'https://forms.googleapis.com/v1/forms').to_return(status: 503)
			stub_request(:post, 'https://forms.googleapis.com/v1/forms/TEST_ID:batchUpdate').to_return(status: 503)
			stub_request(:patch, 'https://www.googleapis.com/drive/v3/files/TEST_ID').to_return(status: 503)

			# Responses expected when trying to show an existing form and the API is down
			stub_request(:get, 'https://forms.googleapis.com/v1/forms/TEST_ID/responses').to_return(status: 503)
			stub_request(:get, 'https://forms.googleapis.com/v1/forms/TEST_ID').to_return(status: 503)

			# Responses expected when trying to destroy a form and the API is down
			stub_request(:delete, 'https://www.googleapis.com/drive/v3/files/TEST_ID').to_return(status: 503)

			# Successfully logged in member with token that hasn't expired
			OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
				provider: 'google_oauth2',
				uid: '123545',
				info: {
				  email: 'testuser@tamu.edu',
				  name: 'Test User'
				},
				credentials: {
				  token: '123456789abc',
				  expires_at: 999999999999999
				}
			  })				

			@event = Event.create(name: 'Party', date: DateTime.now, description: "The good party", location: "My house")   
		end

		context 'Create Forms' do
			scenario 'RSVP Form' do
				visit root_path
				
				click_button 'Login with Google'

				visit events_path

				click_on 'RSVP Form'

				expect(current_path).to eq(show_rsvp_form_event_path(@event))

				expect(page).not_to have_content('RSVP Form for Party')
				expect(page).not_to have_content('Responses')
				expect(page).not_to have_link('Submission Form') 
				expect(page).not_to have_link('Edit In Google Forms')
				expect(page).not_to have_link('Delete Form')
				expect(page).to have_content('Form Does Not Exist')	
				expect(page).to have_link('Create Form', href: create_rsvp_form_event_path(@event))			

				click_on 'Create Form'

				expect(current_path).to eq(events_path)

				expect(page).to have_content('Could not create RSVP form. Please try again later.')
			end

			scenario 'Feedback Form' do
				visit root_path
				
				click_button 'Login with Google'

				visit events_path

				click_on 'Feedback Form'

				expect(current_path).to eq(show_feedback_form_event_path(@event))

				expect(page).not_to have_content('Feedback Form for Party')
				expect(page).not_to have_content('Responses')
				expect(page).not_to have_link('Submission Form') 
				expect(page).not_to have_link('Edit In Google Forms')
				expect(page).not_to have_link('Delete Form')
				expect(page).to have_content('Form Does Not Exist')	
				expect(page).to have_link('Create Form', href: create_feedback_form_event_path(@event))			

				click_on 'Create Form'

				expect(current_path).to eq(events_path)

				expect(page).to have_content('Could not create feedback form. Please try again later.')
			end
		end  

		context 'Destroy Forms' do
			before do
				# Responses expected when successfully creating a form
				stub_request(:post, 'https://forms.googleapis.com/v1/forms').to_return(status: 200, body:
				{
					"formId": "TEST_ID",
					"responderUri": "https://docs.google.com/forms/d/e/VIEW_ID/viewform",
				}.to_json,
				headers: { 'Content-Type' => 'application/json' }
				)
				stub_request(:post, 'https://forms.googleapis.com/v1/forms/TEST_ID:batchUpdate').to_return(status: 200, body: "TEST_BODY")
				stub_request(:patch, 'https://www.googleapis.com/drive/v3/files/TEST_ID').to_return(status: 200)
			end

			scenario 'RSVP Form' do
				visit root_path
				
				click_button 'Login with Google'

				visit events_path

				visit create_rsvp_form_event_path(@event)

				expect(current_path).to eq(events_path)				

				click_on 'RSVP Form'

				expect(current_path).to eq(events_path)

				expect(page).to have_content('Something went wrong. Please try again later.')

				visit destroy_rsvp_form_event_path(@event)

				expect(current_path).to eq (events_path)

				expect(page).to have_content('Could not destroy RSVP form. Please try again later.')				
			end

			scenario 'Feedback Form' do
				visit root_path
				
				click_button 'Login with Google'

				visit events_path

				visit create_feedback_form_event_path(@event)

				expect(current_path).to eq(events_path)				

				click_on 'Feedback Form'

				expect(current_path).to eq(events_path)

				expect(page).to have_content('Something went wrong. Please try again later.')

				visit destroy_feedback_form_event_path(@event)

				expect(current_path).to eq (events_path)

				expect(page).to have_content('Could not destroy feedback form. Please try again later.')	
			end
		end  
	end	

	describe 'Rainy Day (Form Deleted In Drive, Not In App)' do
		before do
			# Responses expected when successfully creating a form
			stub_request(:post, 'https://forms.googleapis.com/v1/forms').to_return(status: 200, body:
			{
				"formId": "TEST_ID",
				"responderUri": "https://docs.google.com/forms/d/e/VIEW_ID/viewform",
			}.to_json,
			headers: { 'Content-Type' => 'application/json' }
			)
			stub_request(:post, 'https://forms.googleapis.com/v1/forms/TEST_ID:batchUpdate').to_return(status: 200, body: "TEST_BODY")
			stub_request(:patch, 'https://www.googleapis.com/drive/v3/files/TEST_ID').to_return(status: 200)

			# Responses expected when trying to show a form that has already been deleted
			stub_request(:get, 'https://forms.googleapis.com/v1/forms/TEST_ID/responses').to_return(status: 404)
			stub_request(:get, 'https://forms.googleapis.com/v1/forms/TEST_ID').to_return(status: 404)

			# Responses expected when trying to delete a form that has already been deleted
			stub_request(:delete, 'https://www.googleapis.com/drive/v3/files/TEST_ID').to_return(status: 404)

			# Successfully logged in member with token that hasn't expired
			OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
				provider: 'google_oauth2',
				uid: '123545',
				info: {
				  email: 'testuser@tamu.edu',
				  name: 'Test User'
				},
				credentials: {
				  token: '123456789abc',
				  expires_at: 999999999999999
				}
			  })				

			@event = Event.create(name: 'Party', date: DateTime.now, description: "The good party", location: "My house")   
		end

		context 'Show Forms' do
			scenario 'RSVP Form' do
				visit root_path
				
				click_button 'Login with Google'

				visit events_path

				click_on 'RSVP Form'		

				click_on 'Create Form'

				expect(current_path).to eq(events_path)

				expect(page).to have_content('Your previous form was inaccessible or deleted. It has been unlinked from your event.')

				click_on 'RSVP Form'

				expect(current_path).to eq(show_rsvp_form_event_path(@event))

				expect(page).not_to have_content('RSVP Form for Party')
				expect(page).not_to have_content('Responses')
				expect(page).not_to have_link('Submission Form') 
				expect(page).not_to have_link('Edit In Google Forms')
				expect(page).not_to have_link('Delete Form')
				expect(page).to have_content('Form Does Not Exist')	
				expect(page).to have_link('Create Form', href: create_rsvp_form_event_path(@event))	
			end

			scenario 'Feedback Form' do
				visit root_path
				
				click_button 'Login with Google'

				visit events_path

				click_on 'Feedback Form'		

				click_on 'Create Form'

				expect(current_path).to eq(events_path)

				expect(page).to have_content('Your previous form was inaccessible or deleted. It has been unlinked from your event.')

				click_on 'Feedback Form'

				expect(current_path).to eq(show_feedback_form_event_path(@event))

				expect(page).not_to have_content('Feedback Form for Party')
				expect(page).not_to have_content('Responses')
				expect(page).not_to have_link('Submission Form') 
				expect(page).not_to have_link('Edit In Google Forms')
				expect(page).not_to have_link('Delete Form')
				expect(page).to have_content('Form Does Not Exist')	
				expect(page).to have_link('Create Form', href: create_feedback_form_event_path(@event))	
			end
		end  

		context 'Destroy Forms' do
			scenario 'RSVP Form' do
				@event.update(rsvp_link: 'TEST_ID')

				visit root_path
				
				click_button 'Login with Google'

				visit events_path

				visit destroy_rsvp_form_event_path(@event)

				expect(current_path).to eq(events_path)

				expect(page).to have_content('Your previous form was inaccessible. It has been unlinked from your event.')	
				click_on 'RSVP Form'

				expect(current_path).to eq(show_rsvp_form_event_path(@event))

				expect(page).not_to have_content('RSVP Form for Party')
				expect(page).not_to have_content('Responses')
				expect(page).not_to have_link('Submission Form') 
				expect(page).not_to have_link('Edit In Google Forms')
				expect(page).not_to have_link('Delete Form')
				expect(page).to have_content('Form Does Not Exist')	
				expect(page).to have_link('Create Form', href: create_rsvp_form_event_path(@event))	
			end

			scenario 'Feedback Form' do
				@event.update(feedback_link: 'TEST_ID')

				visit root_path
				
				click_button 'Login with Google'

				visit events_path

				visit destroy_feedback_form_event_path(@event)

				expect(current_path).to eq(events_path)

				expect(page).to have_content('Your previous form was inaccessible. It has been unlinked from your event.')	
				click_on 'Feedback Form'

				expect(current_path).to eq(show_feedback_form_event_path(@event))

				expect(page).not_to have_content('Feedback Form for Party')
				expect(page).not_to have_content('Responses')
				expect(page).not_to have_link('Submission Form') 
				expect(page).not_to have_link('Edit In Google Forms')
				expect(page).not_to have_link('Delete Form')
				expect(page).to have_content('Form Does Not Exist')	
				expect(page).to have_link('Create Form', href: create_feedback_form_event_path(@event))	
			end
		end  
	end	

	describe 'Rainy Day (Token Expired)' do
		before do
			# Responses expected when trying to create a form and the token is expired
			stub_request(:post, 'https://forms.googleapis.com/v1/forms').to_return(status: 401)
			stub_request(:post, 'https://forms.googleapis.com/v1/forms/TEST_ID:batchUpdate').to_return(status: 401)
			stub_request(:patch, 'https://www.googleapis.com/drive/v3/files/TEST_ID').to_return(status: 401)

			# Responses expected when trying to show a form and the token is expired
			stub_request(:get, 'https://forms.googleapis.com/v1/forms/TEST_ID/responses').to_return(status: 401)
			stub_request(:get, 'https://forms.googleapis.com/v1/forms/TEST_ID').to_return(status: 401)

			# Responses expected when trying to delete a form and the token is expired
			stub_request(:delete, 'https://www.googleapis.com/drive/v3/files/TEST_ID').to_return(status: 401)

			# Successfully logged in member with token that is expired
			OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
				provider: 'google_oauth2',
				uid: '123545',
				info: {
				  email: 'testuser@tamu.edu',
				  name: 'Test User'
				},
				credentials: {
				  token: '123456789abc',
				  expires_at: 5
				}
			  })				

			@event = Event.create(name: 'Party', date: DateTime.now, description: "The good party", location: "My house")   
		end

		context 'Show Forms' do
			scenario 'RSVP Form' do
				@event.update(rsvp_link: 'TEST_ID')

				visit root_path
				
				click_button 'Login with Google'

				visit events_path

				click_on 'RSVP Form'		

				expect(current_path).to eq(sign_in_form_event_path(@event))

				expect(page).to have_link('Back to Events', href: events_path)
				expect(page).to have_content('Sign In Again')
				expect(page).to have_content('Please sign in again to complete the request')
				expect(page).to have_button('Google')

				click_button 'Google'

				# Responses expected when successfully showing an existing form
				stub_request(:get, 'https://forms.googleapis.com/v1/forms/TEST_ID/responses').to_return(status: 200, body: {
					"responses": []
				}.to_json,
				headers: { 'Content-Type' => 'application/json' }
				)
				stub_request(:get, 'https://forms.googleapis.com/v1/forms/TEST_ID').to_return(status: 200, body: {
					"responderUri": "https://docs.google.com/forms/d/e/VIEW_ID/viewform"
				}.to_json,
				headers: { 'Content-Type' => 'application/json' })				

				expect(current_path).to eq(root_path)

				expect(page).to have_content('Signed in successfully via Google.')

				visit events_path

				click_on 'RSVP Form'

				expect(current_path).to eq(show_rsvp_form_event_path(@event))

				expect(page).not_to have_content('Form Does Not Exist')
				expect(page).not_to have_link('Create Form')
				expect(page).to have_content('RSVP Form for Party')
				expect(page).to have_content('Responses: 0')
				expect(page).to have_link('Submission Form', href: 'https://docs.google.com/forms/d/e/VIEW_ID/viewform')
				expect(page).to have_link('Edit In Google Forms', href: 'https://docs.google.com/forms/d/TEST_ID/edit')
				expect(page).to have_link('Delete Form', href: delete_rsvp_form_event_path(@event))	
			end

			scenario 'Feedback Form' do
				@event.update(feedback_link: 'TEST_ID')

				visit root_path
				
				click_button 'Login with Google'

				visit events_path

				click_on 'Feedback Form'		

				expect(current_path).to eq(sign_in_form_event_path(@event))

				expect(page).to have_link('Back to Events', href: events_path)
				expect(page).to have_content('Sign In Again')
				expect(page).to have_content('Please sign in again to complete the request')
				expect(page).to have_button('Google')

				click_button 'Google'

				# Responses expected when successfully showing an existing form
				stub_request(:get, 'https://forms.googleapis.com/v1/forms/TEST_ID/responses').to_return(status: 200, body: {
					"responses": []
				}.to_json,
				headers: { 'Content-Type' => 'application/json' }
				)
				stub_request(:get, 'https://forms.googleapis.com/v1/forms/TEST_ID').to_return(status: 200, body: {
					"responderUri": "https://docs.google.com/forms/d/e/VIEW_ID/viewform"
				}.to_json,
				headers: { 'Content-Type' => 'application/json' })				

				expect(current_path).to eq(root_path)

				expect(page).to have_content('Signed in successfully via Google.')

				visit events_path

				click_on 'Feedback Form'

				expect(current_path).to eq(show_feedback_form_event_path(@event))

				expect(page).not_to have_content('Form Does Not Exist')
				expect(page).not_to have_link('Create Form')
				expect(page).to have_content('Feedback Form for Party')
				expect(page).to have_content('Responses: 0')
				expect(page).to have_link('Submission Form', href: 'https://docs.google.com/forms/d/e/VIEW_ID/viewform')
				expect(page).to have_link('Edit In Google Forms', href: 'https://docs.google.com/forms/d/TEST_ID/edit')
				expect(page).to have_link('Delete Form', href: delete_feedback_form_event_path(@event))		
			end
		end  

		context 'Create Forms' do
			scenario 'RSVP Form' do
				visit root_path
				
				click_button 'Login with Google'

				visit events_path

				click_on 'RSVP Form'

				click_on 'Create Form'

				expect(current_path).to eq(sign_in_form_event_path(@event))

				expect(page).to have_link('Back to Events', href: events_path)
				expect(page).to have_content('Sign In Again')
				expect(page).to have_content('Please sign in again to complete the request')
				expect(page).to have_button('Google')

				click_button 'Google'

				# Responses expected when successfully creating a form
				stub_request(:post, 'https://forms.googleapis.com/v1/forms').to_return(status: 200, body:
				{
					"formId": "TEST_ID",
					"responderUri": "https://docs.google.com/forms/d/e/VIEW_ID/viewform",
				}.to_json,
				headers: { 'Content-Type' => 'application/json' }
				)
				stub_request(:post, 'https://forms.googleapis.com/v1/forms/TEST_ID:batchUpdate').to_return(status: 200, body: "TEST_BODY")
				stub_request(:patch, 'https://www.googleapis.com/drive/v3/files/TEST_ID').to_return(status: 200)

				# Responses expected when successfully showing an existing form
				stub_request(:get, 'https://forms.googleapis.com/v1/forms/TEST_ID/responses').to_return(status: 200, body: {
					"responses": []
				}.to_json,
				headers: { 'Content-Type' => 'application/json' }
				)
				stub_request(:get, 'https://forms.googleapis.com/v1/forms/TEST_ID').to_return(status: 200, body: {
					"responderUri": "https://docs.google.com/forms/d/e/VIEW_ID/viewform"
				}.to_json,
				headers: { 'Content-Type' => 'application/json' })				

				expect(current_path).to eq(root_path)

				expect(page).to have_content('Signed in successfully via Google.')

				visit events_path

				click_on 'RSVP Form'

				expect(current_path).to eq(show_rsvp_form_event_path(@event))

				expect(page).not_to have_content('RSVP Form for Party')
				expect(page).not_to have_content('Responses')
				expect(page).not_to have_link('Submission Form') 
				expect(page).not_to have_link('Edit In Google Forms')
				expect(page).not_to have_link('Delete Form')
				expect(page).to have_content('Form Does Not Exist')	
				expect(page).to have_link('Create Form', href: create_rsvp_form_event_path(@event))						

				click_on 'Create Form'

				expect(current_path).to eq(show_rsvp_form_event_path(@event))

				expect(page).not_to have_content('Form Does Not Exist')
				expect(page).not_to have_link('Create Form')
				expect(page).to have_content('RSVP Form for Party')
				expect(page).to have_content('Responses: 0')
				expect(page).to have_link('Submission Form', href: 'https://docs.google.com/forms/d/e/VIEW_ID/viewform')
				expect(page).to have_link('Edit In Google Forms', href: 'https://docs.google.com/forms/d/TEST_ID/edit')
				expect(page).to have_link('Delete Form', href: delete_rsvp_form_event_path(@event))	
				expect(page).to have_content('RSVP form successfully created.')
			end

			scenario 'Feedback Form' do
				visit root_path
				
				click_button 'Login with Google'

				visit events_path

				click_on 'Feedback Form'

				click_on 'Create Form'

				expect(current_path).to eq(sign_in_form_event_path(@event))

				expect(page).to have_link('Back to Events', href: events_path)
				expect(page).to have_content('Sign In Again')
				expect(page).to have_content('Please sign in again to complete the request')
				expect(page).to have_button('Google')

				click_button 'Google'

				# Responses expected when successfully creating a form
				stub_request(:post, 'https://forms.googleapis.com/v1/forms').to_return(status: 200, body:
				{
					"formId": "TEST_ID",
					"responderUri": "https://docs.google.com/forms/d/e/VIEW_ID/viewform",
				}.to_json,
				headers: { 'Content-Type' => 'application/json' }
				)
				stub_request(:post, 'https://forms.googleapis.com/v1/forms/TEST_ID:batchUpdate').to_return(status: 200, body: "TEST_BODY")
				stub_request(:patch, 'https://www.googleapis.com/drive/v3/files/TEST_ID').to_return(status: 200)

				# Responses expected when successfully showing an existing form
				stub_request(:get, 'https://forms.googleapis.com/v1/forms/TEST_ID/responses').to_return(status: 200, body: {
					"responses": []
				}.to_json,
				headers: { 'Content-Type' => 'application/json' }
				)
				stub_request(:get, 'https://forms.googleapis.com/v1/forms/TEST_ID').to_return(status: 200, body: {
					"responderUri": "https://docs.google.com/forms/d/e/VIEW_ID/viewform"
				}.to_json,
				headers: { 'Content-Type' => 'application/json' })				

				expect(current_path).to eq(root_path)

				expect(page).to have_content('Signed in successfully via Google.')

				visit events_path

				click_on 'Feedback Form'

				expect(current_path).to eq(show_feedback_form_event_path(@event))

				expect(page).not_to have_content('Feedback Form for Party')
				expect(page).not_to have_content('Responses')
				expect(page).not_to have_link('Submission Form') 
				expect(page).not_to have_link('Edit In Google Forms')
				expect(page).not_to have_link('Delete Form')
				expect(page).to have_content('Form Does Not Exist')	
				expect(page).to have_link('Create Form', href: create_feedback_form_event_path(@event))						

				click_on 'Create Form'

				expect(current_path).to eq(show_feedback_form_event_path(@event))

				expect(page).not_to have_content('Form Does Not Exist')
				expect(page).not_to have_link('Create Form')
				expect(page).to have_content('Feedback Form for Party')
				expect(page).to have_content('Responses: 0')
				expect(page).to have_link('Submission Form', href: 'https://docs.google.com/forms/d/e/VIEW_ID/viewform')
				expect(page).to have_link('Edit In Google Forms', href: 'https://docs.google.com/forms/d/TEST_ID/edit')
				expect(page).to have_link('Delete Form', href: delete_feedback_form_event_path(@event))	
				expect(page).to have_content('Feedback form successfully created.')
			end
		end  		

		context 'Destroy Forms' do
			scenario 'RSVP Form' do
				@event.update(rsvp_link: 'TEST_ID')

				visit root_path
				
				click_button 'Login with Google'

				visit events_path

				visit destroy_rsvp_form_event_path(@event)	

				expect(current_path).to eq(sign_in_form_event_path(@event))

				expect(page).to have_link('Back to Events', href: events_path)
				expect(page).to have_content('Sign In Again')
				expect(page).to have_content('Please sign in again to complete the request')
				expect(page).to have_button('Google')

				click_button 'Google'

				# Responses expected when successfully showing an existing form
				stub_request(:get, 'https://forms.googleapis.com/v1/forms/TEST_ID/responses').to_return(status: 200, body: {
					"responses": []
				}.to_json,
				headers: { 'Content-Type' => 'application/json' }
				)
				stub_request(:get, 'https://forms.googleapis.com/v1/forms/TEST_ID').to_return(status: 200, body: {
					"responderUri": "https://docs.google.com/forms/d/e/VIEW_ID/viewform"
				}.to_json,
				headers: { 'Content-Type' => 'application/json' })		
				
				# Responses expected when successfully destroying a form
				stub_request(:delete, 'https://www.googleapis.com/drive/v3/files/TEST_ID').to_return(status: 200)				

				expect(current_path).to eq(root_path)

				expect(page).to have_content('Signed in successfully via Google.')

				visit events_path

				click_on 'RSVP Form'

				expect(current_path).to eq(show_rsvp_form_event_path(@event))

				expect(page).not_to have_content('Form Does Not Exist')
				expect(page).not_to have_link('Create Form')
				expect(page).to have_content('RSVP Form for Party')
				expect(page).to have_content('Responses: 0')
				expect(page).to have_link('Submission Form', href: 'https://docs.google.com/forms/d/e/VIEW_ID/viewform')
				expect(page).to have_link('Edit In Google Forms', href: 'https://docs.google.com/forms/d/TEST_ID/edit')
				expect(page).to have_link('Delete Form', href: delete_rsvp_form_event_path(@event))					

				click_on 'Delete Form'

				expect(current_path).to eq(delete_rsvp_form_event_path(@event))

				expect(page).to have_link('Back to RSVP Form', href: show_rsvp_form_event_path(@event))
				expect(page).to have_content('Are you sure you want to permanently delete this RSVP form?')
				expect(page).to have_content("RSVP Form's Event Name:\nParty")
				expect(page).to have_button('Delete RSVP Form')

				click_button 'Delete RSVP Form'

				expect(current_path).to eq(show_rsvp_form_event_path(@event))

				expect(page).not_to have_content('RSVP Form for Party')
				expect(page).not_to have_content('Responses')
				expect(page).not_to have_link('Submission Form') 
				expect(page).not_to have_link('Edit In Google Forms')
				expect(page).not_to have_link('Delete Form')
				expect(page).to have_content('Form Does Not Exist')	
				expect(page).to have_link('Create Form', href: create_rsvp_form_event_path(@event))
				expect(page).to have_content('RSVP form was successfully destroyed.')				
			end

			scenario 'Feedback Form' do
				@event.update(feedback_link: 'TEST_ID')

				visit root_path
				
				click_button 'Login with Google'

				visit events_path

				visit destroy_feedback_form_event_path(@event)			

				expect(current_path).to eq(sign_in_form_event_path(@event))

				expect(page).to have_link('Back to Events', href: events_path)
				expect(page).to have_content('Sign In Again')
				expect(page).to have_content('Please sign in again to complete the request')
				expect(page).to have_button('Google')

				click_button 'Google'

				# Responses expected when successfully showing an existing form
				stub_request(:get, 'https://forms.googleapis.com/v1/forms/TEST_ID/responses').to_return(status: 200, body: {
					"responses": []
				}.to_json,
				headers: { 'Content-Type' => 'application/json' }
				)
				stub_request(:get, 'https://forms.googleapis.com/v1/forms/TEST_ID').to_return(status: 200, body: {
					"responderUri": "https://docs.google.com/forms/d/e/VIEW_ID/viewform"
				}.to_json,
				headers: { 'Content-Type' => 'application/json' })		
				
				# Responses expected when successfully destroying a form
				stub_request(:delete, 'https://www.googleapis.com/drive/v3/files/TEST_ID').to_return(status: 200)				

				expect(current_path).to eq(root_path)

				expect(page).to have_content('Signed in successfully via Google.')

				visit events_path

				click_on 'Feedback Form'

				expect(current_path).to eq(show_feedback_form_event_path(@event))

				expect(page).not_to have_content('Form Does Not Exist')
				expect(page).not_to have_link('Create Form')
				expect(page).to have_content('Feedback Form for Party')
				expect(page).to have_content('Responses: 0')
				expect(page).to have_link('Submission Form', href: 'https://docs.google.com/forms/d/e/VIEW_ID/viewform')
				expect(page).to have_link('Edit In Google Forms', href: 'https://docs.google.com/forms/d/TEST_ID/edit')
				expect(page).to have_link('Delete Form', href: delete_feedback_form_event_path(@event))					

				click_on 'Delete Form'

				expect(current_path).to eq(delete_feedback_form_event_path(@event))

				expect(page).to have_link('Back to Feedback Form', href: show_feedback_form_event_path(@event))
				expect(page).to have_content('Are you sure you want to permanently delete this feedback form?')
				expect(page).to have_content("Feedback Form's Event Name:\nParty")
				expect(page).to have_button('Delete Feedback Form')

				click_button 'Delete Feedback Form'

				expect(current_path).to eq(show_feedback_form_event_path(@event))

				expect(page).not_to have_content('Feedback Form for Party')
				expect(page).not_to have_content('Responses')
				expect(page).not_to have_link('Submission Form') 
				expect(page).not_to have_link('Edit In Google Forms')
				expect(page).not_to have_link('Delete Form')
				expect(page).to have_content('Form Does Not Exist')	
				expect(page).to have_link('Create Form', href: create_feedback_form_event_path(@event))
				expect(page).to have_content('Feedback form was successfully destroyed.')
			end
		end  
	end		

	describe 'Rainy Day (Try To Create Or Delete Twice)' do
		before do
			# Responses expected when successfully creating a form
			stub_request(:post, 'https://forms.googleapis.com/v1/forms').to_return(status: 200, body:
			{
				"formId": "TEST_ID",
				"responderUri": "https://docs.google.com/forms/d/e/VIEW_ID/viewform",
			}.to_json,
			headers: { 'Content-Type' => 'application/json' }
			)
			stub_request(:post, 'https://forms.googleapis.com/v1/forms/TEST_ID:batchUpdate').to_return(status: 200, body: "TEST_BODY")
			stub_request(:patch, 'https://www.googleapis.com/drive/v3/files/TEST_ID').to_return(status: 200)

			# Responses expected when successfully showing an existing form
			stub_request(:get, 'https://forms.googleapis.com/v1/forms/TEST_ID/responses').to_return(status: 200, body: {
				"responses": []
			}.to_json,
			headers: { 'Content-Type' => 'application/json' }
			)
			stub_request(:get, 'https://forms.googleapis.com/v1/forms/TEST_ID').to_return(status: 200, body: {
				"responderUri": "https://docs.google.com/forms/d/e/VIEW_ID/viewform"
			}.to_json,
			headers: { 'Content-Type' => 'application/json' })

			# Responses expected when successfully destroying a form
			stub_request(:delete, 'https://www.googleapis.com/drive/v3/files/TEST_ID').to_return(status: 200)

			# Successfully logged in member with token that hasn't expired
			OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
				provider: 'google_oauth2',
				uid: '123545',
				info: {
				  email: 'testuser@tamu.edu',
				  name: 'Test User'
				},
				credentials: {
				  token: '123456789abc',
				  expires_at: 999999999999999
				}
			  })				

			@event = Event.create(name: 'Party', date: DateTime.now, description: "The good party", location: "My house")   
		end

		context 'Create Forms' do
			scenario 'RSVP Form' do
				visit root_path
				
				click_button 'Login with Google'

				visit events_path

				click_on 'RSVP Form'	

				click_on 'Create Form'

				visit create_rsvp_form_event_path(@event)

				expect(current_path).to eq(show_rsvp_form_event_path(@event))

				expect(page).to have_content('A form already exists.')
			end

			scenario 'Feedback Form' do
				visit root_path
				
				click_button 'Login with Google'

				visit events_path

				click_on 'Feedback Form'	

				click_on 'Create Form'

				visit create_feedback_form_event_path(@event)

				expect(current_path).to eq(show_feedback_form_event_path(@event))
				
				expect(page).to have_content('A form already exists.')
			end
		end  

		context 'Destroy Forms' do
			scenario 'RSVP Form' do
				@event.update(rsvp_link: 'TEST_ID')

				visit root_path
				
				click_button 'Login with Google'

				visit events_path

				click_on 'RSVP Form'

				click_on 'Delete Form'

				click_on 'Delete RSVP Form'

				visit destroy_rsvp_form_event_path(@event)

				expect(current_path).to eq(show_rsvp_form_event_path(@event))

				expect(page).to have_content('This form has already been deleted.')
			end

			scenario 'Feedback Form' do
				@event.update(feedback_link: 'TEST_ID')

				visit root_path
				
				click_button 'Login with Google'

				visit events_path

				click_on 'Feedback Form'

				click_on 'Delete Form'

				click_on 'Delete Feedback Form'

				visit destroy_feedback_form_event_path(@event)

				expect(current_path).to eq(show_feedback_form_event_path(@event))

				expect(page).to have_content('This form has already been deleted.')
			end
		end  
	end	

	describe 'Rainy Day (API 403 Error)' do
		before do
			# Responses expected when successfully creating a form
			stub_request(:post, 'https://forms.googleapis.com/v1/forms').to_return(status: 200, body:
			{
				"formId": "TEST_ID",
				"responderUri": "https://docs.google.com/forms/d/e/VIEW_ID/viewform",
			}.to_json,
			headers: { 'Content-Type' => 'application/json' }
			)
			stub_request(:post, 'https://forms.googleapis.com/v1/forms/TEST_ID:batchUpdate').to_return(status: 200, body: "TEST_BODY")
			stub_request(:patch, 'https://www.googleapis.com/drive/v3/files/TEST_ID').to_return(status: 200)

			# Responses expected when trying to show a form with 403 error
			stub_request(:get, 'https://forms.googleapis.com/v1/forms/TEST_ID/responses').to_return(status: 403)
			stub_request(:get, 'https://forms.googleapis.com/v1/forms/TEST_ID').to_return(status: 403)

			# Responses expected when trying to delete a form with 403 error
			stub_request(:delete, 'https://www.googleapis.com/drive/v3/files/TEST_ID').to_return(status: 403)

			# Successfully logged in member with token that hasn't expired
			OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
				provider: 'google_oauth2',
				uid: '123545',
				info: {
				  email: 'testuser@tamu.edu',
				  name: 'Test User'
				},
				credentials: {
				  token: '123456789abc',
				  expires_at: 999999999999999
				}
			  })				

			@event = Event.create(name: 'Party', date: DateTime.now, description: "The good party", location: "My house")   
		end

		context 'Show Forms' do
			scenario 'RSVP Form' do
				visit root_path
				
				click_button 'Login with Google'

				visit events_path

				click_on 'RSVP Form'		

				click_on 'Create Form'

				expect(current_path).to eq(events_path)

				expect(page).to have_content('Something went wrong. Please try again later.')
			end

			scenario 'Feedback Form' do
				visit root_path
				
				click_button 'Login with Google'

				visit events_path

				click_on 'Feedback Form'		

				click_on 'Create Form'

				expect(current_path).to eq(events_path)

				expect(page).to have_content('Something went wrong. Please try again later.')
			end
		end  

		context 'Destroy Forms' do
			scenario 'RSVP Form' do
				@event.update(rsvp_link: 'TEST_ID')

				visit root_path
				
				click_button 'Login with Google'

				visit events_path

				visit destroy_rsvp_form_event_path(@event)

				expect(current_path).to eq(events_path)

				expect(page).to have_content('Could not destroy RSVP form. Please try again later.')	
			end

			scenario 'Feedback Form' do
				@event.update(feedback_link: 'TEST_ID')

				visit root_path
				
				click_button 'Login with Google'

				visit events_path

				visit destroy_feedback_form_event_path(@event)

				expect(current_path).to eq(events_path)

				expect(page).to have_content('Could not destroy feedback form. Please try again later.')	
			end
		end  
	end	

	describe 'Sunny Day (Multiple Responses)' do
		before do
			# Responses expected when successfully creating a form
			stub_request(:post, 'https://forms.googleapis.com/v1/forms').to_return(status: 200, body:
			{
				"formId": "TEST_ID",
				"responderUri": "https://docs.google.com/forms/d/e/VIEW_ID/viewform",
			}.to_json,
			headers: { 'Content-Type' => 'application/json' }
			)
			stub_request(:post, 'https://forms.googleapis.com/v1/forms/TEST_ID:batchUpdate').to_return(status: 200, body: "TEST_BODY")
			stub_request(:patch, 'https://www.googleapis.com/drive/v3/files/TEST_ID').to_return(status: 200)

			# Responses expected when successfully showing an existing form (blank responses)
			stub_request(:get, 'https://forms.googleapis.com/v1/forms/TEST_ID/responses').to_return(status: 200, body: {
				"responses": [
					{
						"formId": "Response1"
					},
					{
						"formId": "Response2"
					}
				]
			}.to_json,
			headers: { 'Content-Type' => 'application/json' }
			)
			stub_request(:get, 'https://forms.googleapis.com/v1/forms/TEST_ID').to_return(status: 200, body: {
				"responderUri": "https://docs.google.com/forms/d/e/VIEW_ID/viewform"
			}.to_json,
			headers: { 'Content-Type' => 'application/json' })

			# Responses expected when successfully destroying a form
			stub_request(:delete, 'https://www.googleapis.com/drive/v3/files/TEST_ID').to_return(status: 200)

			# Successfully logged in member with token that hasn't expired
			OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
				provider: 'google_oauth2',
				uid: '123545',
				info: {
				  email: 'testuser@tamu.edu',
				  name: 'Test User'
				},
				credentials: {
				  token: '123456789abc',
				  expires_at: 999999999999999
				}
			  })				

			@event = Event.create(name: 'Party', date: DateTime.now, description: "The good party", location: "My house")   
		end

		context 'Show Forms' do
			scenario 'RSVP Form' do
				visit root_path
				
				click_button 'Login with Google'

				visit events_path

				click_on 'RSVP Form'		

				click_on 'Create Form'

				expect(current_path).to eq(show_rsvp_form_event_path(@event))

				expect(page).not_to have_content('Form Does Not Exist')
				expect(page).not_to have_link('Create Form')
				expect(page).to have_content('RSVP Form for Party')
				expect(page).to have_content('Responses: 2')
				expect(page).to have_link('Submission Form', href: 'https://docs.google.com/forms/d/e/VIEW_ID/viewform')
				expect(page).to have_link('Edit In Google Forms', href: 'https://docs.google.com/forms/d/TEST_ID/edit')
				expect(page).to have_link('Delete Form', href: delete_rsvp_form_event_path(@event))
			end

			scenario 'Feedback Form' do
				visit root_path
				
				click_button 'Login with Google'

				visit events_path

				click_on 'Feedback Form'		

				click_on 'Create Form'

				expect(current_path).to eq(show_feedback_form_event_path(@event))

				expect(page).not_to have_content('Form Does Not Exist')
				expect(page).not_to have_link('Create Form')
				expect(page).to have_content('Feedback Form for Party')
				expect(page).to have_content('Responses: 2')
				expect(page).to have_link('Submission Form', href: 'https://docs.google.com/forms/d/e/VIEW_ID/viewform')
				expect(page).to have_link('Edit In Google Forms', href: 'https://docs.google.com/forms/d/TEST_ID/edit')
				expect(page).to have_link('Delete Form', href: delete_feedback_form_event_path(@event))
			end
		end  
	end

end