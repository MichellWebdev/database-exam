async function likeTweet(tweet_id) {
  event.target.style.fill = 'rgba(29, 161, 242, 1)';

  let tweetLikes = event.target.parentNode.nextElementSibling.innerText;
  tweetLikes++;
  event.target.parentNode.nextElementSibling.innerText = tweetLikes;

  let likeTweetForm = new FormData();
  likeTweetForm.append('tweet_id', tweet_id);

  let connection = await fetch('api/api-like-tweet.php', {
    method: 'POST',
    body: likeTweetForm,
  });
  if (connection.status != 200) {
    console.log('error');
  }
  let response = connection.text();
}
