class API < Cuba; end                                                                                                                         
API.define do
  on get do
   on "api/confidential" do
     if env['rack.auth'].authenticate!
       res.write "Greetings from inside"
     else
       res.status = 400
     end
   end

   on "api/public" do
     res.write "Greetings from outside"
   end

   on "default" do
     res.write "API: /api/confidential, /api/public"
   end
  end
end
