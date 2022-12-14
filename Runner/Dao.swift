import Foundation
import UIKit
import FMDB

class Dao: NSObject {
    
    static let shared = Dao()
    
    var fileName: String = "demo.db" // sqlite name
    var filePath: String = "" // sqlite path
    var database: FMDatabase! // FMDBConnection
    
    private override init() {
        super.init()
        
        // 取得sqlite在documents下的路徑(開啟連線用)
        self.filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/" + self.fileName
        
        print("filePath: \(self.filePath)")
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    /// 生成 .sqlite 檔案並創建表格，只有在 .sqlite 不存在時才會建立
    func createTable() {
        let fileManager: FileManager = FileManager.default
        
        // 判斷documents是否已存在該檔案
        if !fileManager.fileExists(atPath: self.filePath) {
            
            // 開啟連線
            if self.openConnection() {
                let createTableSQL = """
                    CREATE TABLE DEPARTMENT (
                    DEPARTMENT_ID integer  NOT NULL  PRIMARY KEY DEFAULT 0,
                    DEPT_CH_NM Varchar(100),
                    DEPT_EN_NM Varchar(100))
                """
                self.database.executeStatements(createTableSQL)
                print("file copy to: \(self.filePath)")
            }
        } else {
            print("DID-NOT copy db file, file allready exists at path:\(self.filePath)")
        }
    }
    
    /// 取得 .sqlite 連線
    ///
    /// - Returns: Bool
    func openConnection() -> Bool {
        var isOpen: Bool = false
        
        self.database = FMDatabase(path: self.filePath)
        
        if self.database != nil {
            if self.database.open() {
                isOpen = true
            } else {
                print("Could not get the connection.")
            }
        }
        
        return isOpen
    }
    
    /// 新增部門資料
    ///
    /// - Parameters:
    ///   - departmentEnglistName: 部門中文名稱
    ///   - departmentChineseName: 部門英文名稱
    func insertData() {
        
        if self.openConnection() {
            let insertSQL: String = "INSERT INTO message (type, title,content,time,isRead) VALUES(7,'iosNotificationTtile2','iosNotificationContent2',1233211232,0)"
            
            if !self.database.executeUpdate(insertSQL, withArgumentsIn: []) {
                print("Failed to insert initial data into the database.")
                print(database.lastError(), database.lastErrorMessage())
            }
            
            self.database.close()
        }
    }
    
    /// 更新部門資料
    ///
    /// - Parameters:
    ///   - departmentId: 部門ID
    ///   - departmentEnglistName: 部門中文名稱
    ///   - departmentChineseName: 部門英文名稱
    func updateData(withDepartmentId departmentId: Int, departmentChineseName: String, departmentEnglistName: String) {
        if self.openConnection() {
            let updateSQL: String = "UPDATE DEPARTMENT SET DEPT_CH_NM = ?, DEPT_EN_NM = ? WHERE DEPARTMENT_ID = ?"
            
            do {
                try self.database.executeUpdate(updateSQL, values: [departmentChineseName, departmentEnglistName, departmentId])
            } catch {
                print(error.localizedDescription)
            }
            
            self.database.close()
        }
    }
    
    /// 取得部門的所有資料
    ///
    /// - Returns: 部門資料
    func queryData()  {
        if self.openConnection() {
            let querySQL: String = "SELECT * FROM message"
            
            do {
                let dataLists: FMResultSet = try database.executeQuery(querySQL, values: nil)
                
                while dataLists.next() {
                    print("####id=\(dataLists.int(forColumn: "id"))")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    /// 刪除部門資料
    ///
    /// - Parameter departmentId: 部門ID
    func deleteData(withDepartmentId departmentId: Int) {
        if self.openConnection() {
            let deleteSQL: String = "DELETE FROM DEPARTMENT WHERE DEPARTMENT_ID = ?"
            
            do {
                try self.database.executeUpdate(deleteSQL, values: [departmentId])
            } catch {
                print(error.localizedDescription)
            }
            
            self.database.close()
        }
    }
}
