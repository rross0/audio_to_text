# This is a demonstration of audio to text translation using 
# Microsoft Azure's Cognitive Resources
# Libraries

# ---- Setup ----
library(audio); library(here)
library(httr); library(jsonlite)

source(here::here("azure_keys.R"))

# ----- Record audio -----
#Set our recording time
rec_time <- 5 

Samples<-rep(NA_real_, 44100 * rec_time) #Defining number of samples recorded
print("Start speaking")
audio_obj <- audio::record(Samples, 44100, 1) #Create an audio instance with sample rate 44100 and mono channel
wait(6)
rec <- audio_obj$data # get the recorded data from the audio object

save.wave(rec, here::here("hello_tess.wav_here.wav"))

# ---- Transcribe----

#Define headers containing subscription key and content type
headers = c(
  `Ocp-Apim-Subscription-Key` = KEY1,  #Key 1 or 2
  `Content-Type` = 'audio/wav' #Since we are transcribing a WAV file
)

#Create a parameters list, in this case we specify the languange parameter
params = list(
  `language` = 'en-US'
)

#Enter path to the audio file we just recorded and saved
data = upload_file (here::here("hello_tess.wav_here.wav")) 

#Make the API call and save the response recived
response <- httr::POST(url = 'https://eastus.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1', 
                       httr::add_headers(.headers=headers), query = params, body = data)

#Convert response received to a dataframe
result <- fromJSON(content(response, as  = 'text')) 
txt_output <- as.data.frame(result)

#Extract transcribed text
txt_input <- txt_output[1,4]
txt_input