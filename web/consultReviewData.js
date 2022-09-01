let reviewData;
const getReviewData = async () => {
    await fetch("https://somunbackend.com/auth-non/review", {
        method: "GET",
        headers: {
        }
    })
        .then((res) => {
            return res.json();
        })
        .then((res) => {
            reviewData = res;
            makeImgReview();
        })
        .catch((err) => {
            console.log(err);
        })
}

const makeImgReview = () => {
    for(let i = 0; i < reviewData.length; i++){
        makeImgReviewBox(reviewData[i]);
    }

}

getReviewData();

