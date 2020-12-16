async function updateTweet() {
  let updateTweetForm = new FormData();
  updateTweetForm.append('tweet_id', event.target.parentNode.parentNode.id);
  updateTweetForm.append('tweet_message', document.querySelector('.tweet_message'));

  let connection = await fetch('api/api-update-tweet.php', {
    method: 'POST',
    body: updateTweetForm,
  });

  if (connection.status != '200') {
    console.log('tweet could not be updated');
  }

  // update message that is shown so reload is not neccesary

  // Maybe let the id come form response and do the form append for the tweet message??
}
