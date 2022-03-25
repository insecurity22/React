<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>

public class Pagination {
		int nowPage;
		int totalDataCnt;
		int totalPageCnt;
		Statement stmt;
		int blockCnt;
		int blockStart;
		int blockEnd;
		int listCnt;
		int listStart;
		int listEnd;
		int idx;
		ResultSet rst;

		/** 
			* @param nowPage 현재페이지
			* @param blockCnt 한 페이지에 보여줄 아래 페이징 블럭 개수
			* @param listCnt 한 페이지에 보여줄 리스트 개수
			* @param totalDataCnt 총 페이지 수, 다시 계산해야하는 경우 0으로
			* @param stmt db connection
		*/
		public Pagination(int nowPage, int blockCnt, int listCnt, int totalDataCnt, Statement stmt) {
			this.nowPage = nowPage;
			this.blockCnt = blockCnt;
			this.listCnt = listCnt;
			this.totalDataCnt = totalDataCnt;
			this.stmt = stmt;
		}

		// totalDataCnt 계산 후 업데이트
		public void updateTotalDataCnt(String sql) {
			try {
				ResultSet rst = this.stmt.executeQuery(sql);
				if(rst.next()) { 
					this.totalDataCnt = rst.getInt(1); 
				}
				rst.close();
			} catch(SQLException e) {
				System.err.println("SQLException 발생했습니다. : "  + sql);
				System.err.println(e);
			}
		}

		public ResultSet create(String sql) {		

			// List			
			this.listStart = ((this.nowPage-1)*this.listCnt);
			this.listEnd = this.listStart + this.listCnt-1;
			this.totalPageCnt = (int)Math.ceil((double)this.totalDataCnt/this.listCnt);
			
			// Block				
			this.blockEnd = (int)Math.ceil((double)this.nowPage/this.blockCnt)*this.blockCnt;
			this.blockStart = blockEnd - this.blockCnt + 1; 
			this.rst = null;
			try {
				sql = sql + " limit " + this.listStart + ", " + this.listCnt;
				this.rst = this.stmt.executeQuery(sql);
				System.out.println(sql);
			} catch(SQLException e) {
				System.err.println("SQLException 발생했습니다. : "  + sql);
				System.err.println(e);
			}
			return this.rst;
		}

		public JSONObject getJSONData() {
			JSONObject jsonObject = new JSONObject();
			JSONObject paging = new JSONObject();
			paging.put("nowPage", this.nowPage);
			paging.put("totalDataCnt", this.totalDataCnt);
			paging.put("totalPageCnt", this.totalPageCnt);
			paging.put("blockCnt", this.blockCnt);
			paging.put("blockStart", this.blockStart);
			paging.put("blockEnd", this.blockEnd);
			paging.put("listCnt", this.listCnt);
			paging.put("listStart", this.listStart);
			paging.put("listEnd", this.listEnd);

			int i_no = 0;
			JSONArray dataArr = new JSONArray();
			try {
				while(this.rst.next()) {
					i_no = i_no + 1;
					this.idx = this.listCnt*(this.nowPage-1) + i_no;
					JSONObject obj = new JSONObject();
					ResultSetMetaData rsmd = rst.getMetaData();
					int total_rows = rsmd.getColumnCount();
					for (int i=0; i<total_rows; i++){
						String columnName = rsmd.getColumnLabel(i+1);
						Object columnValue = rst.getObject(i+1);
						obj.put(columnName, columnValue);
					}
					dataArr.add(obj);
				}
			} catch(SQLException e) {
				System.err.println("SQLException 발생했습니다. : " + e);
			}
			jsonObject.put("paging", paging);
			jsonObject.put("datalist", dataArr);
			return jsonObject;
		}
	};