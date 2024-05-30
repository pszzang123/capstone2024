# 세부 영수증 배송 상태 변경

## 목차

- [구성](#구성)
- [Request](#request)
- [Response](#response)

## 구성

<table>
<tr>
  <td>HTTP 메서드</td>
  <td>
    <img src="https://img.shields.io/badge/PUT-blue">
  </td>
</tr>
<tr>
  <td>API</td>
  <td>

  `/api/receipt_detail/{receiptDetailId}/{status}`

  </td>
</tr>
<tr>
  <td>Request Body</td>
  <td>
    .
  </td>
</tr>
<tr>
  <td>Response Body</td>
  <td>
    <img src="https://img.shields.io/badge/JSON-purple">
  </td>
</tr>
</table>

## Request

```json

```

<br/>

## Response

#### Value Type 
<table>
<tr>
  <th>key</th>
  <th>value type</th>
</tr>
<tr>
    <td>receiptDetailId</td>
    <td><img src="https://img.shields.io/badge/number-grey"></td>
</tr>
<tr>
    <td>receiptId</td>
    <td><img src="https://img.shields.io/badge/number-grey"></td>
</tr>
<tr>
    <td>detailId</td>
    <td><img src="https://img.shields.io/badge/number-grey"></td>
</tr>
<tr>
    <td>quantity</td>
    <td><img src="https://img.shields.io/badge/number-grey"></td>
</tr>
<tr>
    <td>status</td>
    <td><img src="https://img.shields.io/badge/number-grey"></td>
</tr>
</table>

<br/>

```json
{
    "receiptDetailId": ,
    "receiptId": ,
    "detailId": ,
    "quantity": ,
    "status": 
}
```

<br/>
