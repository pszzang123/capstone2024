# Backend Document

## 📋목차

1. [프로젝트 구성](#프로젝트-구성)
2. [ERD](#erd)
3. [REST API](#rest-api)
4. [개선점](#개선점)

## 📋프로젝트 구성

![](./image.png)

<br/>

## 📋ERD

![](./논리적%20ERD.png)

<br/>

## 📋REST API

1. [Cart](#cart)
2. [Clothes](#clothes)
3. [Clothes Detail](#clothes-detail)
4. [Clothes Images](#clothes-images)
5. [Comment](#comment)
6. [Customer](#customer)
7. [Likes](#likes)
8. [Major Category](#major-category)
9. [Receipt](#receipt)
10. [Receipt Detail](#receipt-detail)
11. [Sales](#sales)
12. [Seller](#seller)
13. [Sub Category](#sub-category)

<div>
<table>

<tr>
<th>API</th>
<th>HTTP 메서드</th>
<th>Request Body</th>
<th>Response Body</th>
<th>기능</th>
</tr>

<!--Cart-->
<tr>
<td colspan="5">

### Cart

</td>
</tr>

<tr>
  <td>

  `/api/cart`

  </td>
  <td>
    <img src="https://img.shields.io/badge/POST-yellow">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/cart/createCart.md">장바구니 추가</a>
  </td>
</tr>

<tr>
  <td>

  `/api/cart/{email}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/cart/getCartByCustomerEmail.md">회원 장바구니 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/cart`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/cart/getAllCart.md">모든 장바구니 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/cart/{email}/{cartId}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/PUT-blue">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/cart/updateCart.md">장바구니 수정</a>
  </td>
</tr>

<tr>
  <td>

  `/api/cart/{email}/{cartId}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/DELETE-red">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/string-grey">
  </td>
  <td>
    <a href="./api/cart/deleteCart.md">장바구니 제거</a>
  </td>
</tr>
<!--Cart-->



<!--Clothes-->
<tr>
<td colspan="5">

### Clothes

</td>
</tr>

<tr>
  <td>

  `/api/clothes`

  </td>
  <td>
    <img src="https://img.shields.io/badge/POST-yellow">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/clothes/createClothes.md">의류 추가</a>
  </td>
</tr>

<tr>
  <td>

  `/api/clothes/{clothesId}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/clothes/getClothesById.md">의류 정보 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/clothes/seller/{email}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/clothes/getClothesBySeller.md">판매자 의류 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/clothes/statistics/{clothesId}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/clothes/getStatisticsById.md">관리자용 의류 판매 정보 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/clothes/search/{clothesName}?gender=&major_category=&sub_category=`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/clothes/getClothesByName.md">이름으로 의류 검색</a>
  </td>
</tr>

<tr>
  <td>

  `/api/clothes?gender=&major_category=&sub_category=`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/clothes/getAllClothes.md">모든(카테고리별) 의류 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/clothes/sort/{sortId}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/PUT-blue">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/clothes/sortClothes.md">의류 정렬</a>
  </td>
</tr>

<tr>
  <td>

  `/api/clothes/view/{clothesId}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/PUT-blue">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/clothes/sortClothes.md">조회수 증가</a>
  </td>
</tr>

<tr>
  <td>

  `/api/clothes/{clothesId}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/PUT-blue">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/clothes/updateClothes.md">의류 정보 수정</a>
  </td>
</tr>

<tr>
  <td>

  `/api/clothes/{clothesId}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/DELETE-red">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/string-grey">
  </td>
  <td>
    <a href="./api/clothes/deleteClothes.md">의류 제거</a>
  </td>
</tr>
<!--Clothes-->



<!--Clothes Detail-->
<tr>
<td colspan="5">

### Clothes Detail

</td>
</tr>

<tr>
  <td>

  `/api/detail`

  </td>
  <td>
    <img src="https://img.shields.io/badge/POST-yellow">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/clothes detail/createClothesDetail.md">의류 상세정보(옵션적용) 추가</a>
  </td>
</tr>

<tr>
  <td>

  `/api/detail/{detailId}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/clothes detail/getClothesDetailById.md">의류 상세정보 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/detail/clothes/{clothesId}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/clothes detail/getClothesDetailsByClothes.md">의류에 포함된 모든 상세정보 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/detail`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/clothes detail/getAllClothesDetail.md">모든 의류 상세정보 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/detail/{detailId}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/PUT-blue">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/clothes detail/updateClothesDetail.md">의류 상세정보 수정</a>
  </td>
</tr>

<tr>
  <td>

  `/api/detail/{detailId}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/DELETE-red">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/string-grey">
  </td>
  <td>
    <a href="./api/clothes detail/deleteClothesDetail.md">의류 상세정보 제거</a>
  </td>
</tr>

<tr>
  <td>

  `/api/detail/clothes/{clothesId}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/DELETE-red">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/string-grey">
  </td>
  <td>
    <a href="./api/clothes detail/deleteClothesDetailByClothesId.md">의류에 포함된 모든 상세정보 제거</a>
  </td>
</tr>
<!--Clothes Detail-->



<!--Clothes Images-->
<tr>
<td colspan="5">

### Clothes Images

</td>
</tr>

<tr>
  <td>

  `/api/clothes_images`

  </td>
  <td>
    <img src="https://img.shields.io/badge/POST-yellow">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/clothes images/createClothesImages.md">의류 이미지 추가</a>
  </td>
</tr>

<tr>
  <td>

  `/api/clothes_images/{clothesId}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/clothes images/getImageUrlByClothesId.md">의류에 포함된 모든 이미지 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/clothes_images`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/clothes images/getAllClothesImages.md">모든 의류 이미지 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/clothes_images`

  </td>
  <td>
    <img src="https://img.shields.io/badge/PUT-blue">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/clothes images/updateAllClothesImages.md">모든 의류 이미지 변경</a>
  </td>
</tr>

<tr>
  <td>

  `/api/clothes_images/{clothesId}/{prevOrder}/{nextOrder}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/PUT-blue">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/clothes images/changeClothesPosition.md">의류 순서 변경</a>
  </td>
</tr>

<tr>
  <td>

  `/api/clothes_images/{clothesId}/{order}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/DELETE-red">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/string-grey">
  </td>
  <td>
    <a href="./api/clothes images/deleteClothesImagesByOrder.md">의류 순서에 해당하는 이미지 제거</a>
  </td>
</tr>
<!--Clothes Images-->



<!--Comment-->
<tr>
<td colspan="5">

### Comment

</td>
</tr>

<tr>
  <td>

  `/api/comment`

  </td>
  <td>
    <img src="https://img.shields.io/badge/POST-yellow">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/comment/createComment.md">댓글 추가</a>
  </td>
</tr>

<tr>
  <td>

  `/api/comment/{email}/{commentId}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/comment/getCommentById.md">회원이 의류에 작성한 댓글 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/comment/customer/{email}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/comment/getCommentsByCustomer.md">회원이 작성한 모든 댓글 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/comment/clothes/{clothesId}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/comment/getCommentsByClothes.md">의류에 작성된 모든 댓글 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/comment`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/comment/getAllComment.md">모든 댓글 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/comment`

  </td>
  <td>
    <img src="https://img.shields.io/badge/PUT-blue">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/comment/updateComment.md">댓글 수정</a>
  </td>
</tr>

<tr>
  <td>

  `/api/comment/{email}/{commentId}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/DELETE-red">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/string-grey">
  </td>
  <td>
    <a href="./api/comment/deleteComment.md">댓글 제거</a>
  </td>
</tr>
<!--Comment-->



<!--Customer-->
<tr>
<td colspan="5">

### Customer

</td>
</tr>

<tr>
  <td>

  `/api/customers`

  </td>
  <td>
    <img src="https://img.shields.io/badge/POST-yellow">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/customers/createCustomer.md">회원 가입</a>
  </td>
</tr>

<tr>
  <td>

  `/api/customers/{email}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/customers/getCustomerByEmail.md">회원 정보 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/customers/{email}/{password}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/boolean-grey">
  </td>
  <td>
    <a href="./api/customers/checkCustomerByLoginInfo.md">로그인 정보 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/customers/email/{email}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/boolean-grey">
  </td>
  <td>
    <a href="./api/customers/checkCustomerByEmail.md">이메일 중복 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/customers`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/customers/getAllCustomers.md">모든 회원 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/customers/{email}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/PUT-blue">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/customers/updateCustomer.md">회원 정보 수정</a>
  </td>
</tr>

<tr>
  <td>

  `/api/customers/{email}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/DELETE-red">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/string-grey">
  </td>
  <td>
    <a href="./api/customers/deleteCustomer.md">회원 탈퇴</a>
  </td>
</tr>
<!--Customer-->



<!--Likes-->
<tr>
<td colspan="5">

### Likes

</td>
</tr>

<tr>
  <td>

  `/api/like`

  </td>
  <td>
    <img src="https://img.shields.io/badge/POST-yellow">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/likes/createLikes.md">좋아요 추가</a>
  </td>
</tr>

<tr>
  <td>

  `/api/like/{email}/{clothesId}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/likes/getLikesById.md">회원이 의류에 좋아요 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/like/customer/{email}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/likes/getLikesByCustomer.md">회원이 좋아요한 의류 리스트 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/like/clothes/{clothesId}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/likes/getLikesByClothes.md">의류에 좋아요한 회원 리스트 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/like`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/likes/getAllLikes.md">모든 좋아요 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/like/{email}/{clothesId}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/DELETE-red">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/string-grey">
  </td>
  <td>
    <a href="./api/likes/deleteLikes.md">좋아요 제거</a>
  </td>
</tr>
<!--Likes-->



<!--Major Category-->
<tr>
<td colspan="5">

### Major Category

</td>
</tr>

<tr>
  <td>

  `/api/major_category`

  </td>
  <td>
    <img src="https://img.shields.io/badge/POST-yellow">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/major category/createMajorCategory.md">주 카테고리 추가</a>
  </td>
</tr>

<tr>
  <td>

  `/api/major_category/{majorCategoryId}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/major category/getMajorCategoryById.md">주 카테고리 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/major_category`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/major category/getAllMajorCategory.md">모든 주 카테고리 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/major_category/{id}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/DELETE-red">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/string-grey">
  </td>
  <td>
    <a href="./api/major category/deleteMajorCategory.md">주 카테고리 제거</a>
  </td>
</tr>
<!--Major Category-->



<!--Receipt-->
<tr>
<td colspan="5">

### Receipt

</td>
</tr>

<tr>
  <td>

  `/api/receipt`

  </td>
  <td>
    <img src="https://img.shields.io/badge/POST-yellow">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/receipt/createReceipt.md">영수증 추가</a>
  </td>
</tr>

<tr>
  <td>

  `/api/receipt/{email}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/receipt/getReceiptByCustomerEmail.md">회원 영수증 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/receipt`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/receipt/getAllReceipt.md">모든 영수증 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/cart/{email}/{id}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/PUT-blue">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/cart/updateCart.md">장바구니 수정</a>
  </td>
</tr>

<tr>
  <td>

  `/api/cart/{email}/{id}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/DELETE-red">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/string-grey">
  </td>
  <td>
    <a href="./api/cart/deleteCart.md">장바구니 제거</a>
  </td>
</tr>
<!--Receipt-->



<!--Receipt Detail-->
<tr>
<td colspan="5">

### Receipt Detail

</td>
</tr>

<tr>
  <td>

  `/api/cart`

  </td>
  <td>
    <img src="https://img.shields.io/badge/POST-yellow">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/cart/createCart.md">장바구니 추가</a>
  </td>
</tr>

<tr>
  <td>

  `/api/cart/{email}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/boolean-grey">
  </td>
  <td>
    <a href="./api/cart/getCartByCustomerEmail.md">회원 장바구니 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/cart`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/cart/getAllCart.md">모든 장바구니 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/cart/{email}/{id}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/PUT-blue">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/cart/updateCart.md">장바구니 수정</a>
  </td>
</tr>

<tr>
  <td>

  `/api/cart/{email}/{id}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/DELETE-red">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/string-grey">
  </td>
  <td>
    <a href="./api/cart/deleteCart.md">장바구니 제거</a>
  </td>
</tr>
<!--Receipt Detail-->



<!--Sales-->
<tr>
<td colspan="5">

### Sales

</td>
</tr>

<tr>
  <td>

  `/api/cart`

  </td>
  <td>
    <img src="https://img.shields.io/badge/POST-yellow">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/cart/createCart.md">장바구니 추가</a>
  </td>
</tr>

<tr>
  <td>

  `/api/cart/{email}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/boolean-grey">
  </td>
  <td>
    <a href="./api/cart/getCartByCustomerEmail.md">회원 장바구니 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/cart`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/cart/getAllCart.md">모든 장바구니 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/cart/{email}/{id}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/PUT-blue">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/cart/updateCart.md">장바구니 수정</a>
  </td>
</tr>

<tr>
  <td>

  `/api/cart/{email}/{id}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/DELETE-red">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/string-grey">
  </td>
  <td>
    <a href="./api/cart/deleteCart.md">장바구니 제거</a>
  </td>
</tr>
<!--Sales-->



<!--Seller-->
<tr>
<td colspan="5">

### Seller

</td>
</tr>

<tr>
  <td>

  `/api/cart`

  </td>
  <td>
    <img src="https://img.shields.io/badge/POST-yellow">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/cart/createCart.md">장바구니 추가</a>
  </td>
</tr>

<tr>
  <td>

  `/api/cart/{email}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/boolean-grey">
  </td>
  <td>
    <a href="./api/cart/getCartByCustomerEmail.md">회원 장바구니 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/cart`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/cart/getAllCart.md">모든 장바구니 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/cart/{email}/{id}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/PUT-blue">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/cart/updateCart.md">장바구니 수정</a>
  </td>
</tr>

<tr>
  <td>

  `/api/cart/{email}/{id}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/DELETE-red">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/string-grey">
  </td>
  <td>
    <a href="./api/cart/deleteCart.md">장바구니 제거</a>
  </td>
</tr>
<!--Seller-->



<!--Sub Category-->
<tr>
<td colspan="5">

### Sub Category

</td>
</tr>

<tr>
  <td>

  `/api/cart`

  </td>
  <td>
    <img src="https://img.shields.io/badge/POST-yellow">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/cart/createCart.md">장바구니 추가</a>
  </td>
</tr>

<tr>
  <td>

  `/api/cart/{email}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/boolean-grey">
  </td>
  <td>
    <a href="./api/cart/getCartByCustomerEmail.md">회원 장바구니 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/cart`

  </td>
  <td>
    <img src="https://img.shields.io/badge/GET-green">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/cart/getAllCart.md">모든 장바구니 확인</a>
  </td>
</tr>

<tr>
  <td>

  `/api/cart/{email}/{id}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/PUT-blue">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
  <td>
    <a href="./api/cart/updateCart.md">장바구니 수정</a>
  </td>
</tr>

<tr>
  <td>

  `/api/cart/{email}/{id}`

  </td>
  <td>
    <img src="https://img.shields.io/badge/DELETE-red">
  </td>
  <td>
    .
  </td>
  <td>
    <img src="https://img.shields.io/badge/string-grey">
  </td>
  <td>
    <a href="./api/cart/deleteCart.md">장바구니 제거</a>
  </td>
</tr>
<!--Sub Category-->

</table>
</div>


<br/>

## 📋개선점
1. API 권한 추가
2. User 회원가입 시 Password 암호화