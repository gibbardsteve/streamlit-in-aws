import streamlit as st
import pandas as pd

st.title('Test File Read and Write!')
st.write('This is a simple Streamlit app.')

# Add a sidebar to upload a file
uploaded_file = st.sidebar.file_uploader('Upload your CSV file', type=['csv'])

# If a file was uploaded, display the csv as a data table
if uploaded_file is not None:
    df = pd.read_csv(uploaded_file)
    st.dataframe(df)

# Add a button to save the file as a different name
if st.button('Save as CSV'):
    df.to_csv('saved_output.csv', index=False)
    st.write('File saved as output.csv')
