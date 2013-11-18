//
//  YJDatabase_c.h
//  TestYJFramework
//
//  Created by szfore on 13-5-30.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#ifndef TestYJFramework_YJDatabase_c_h
#define TestYJFramework_YJDatabase_c_h

#include "YJDatabaseDefine.h"
#include <sqlite3.h>
#import "YJString.h"
enum
{
    kInt=0,
    kText
};
typedef NSInteger YJDatabaseType;
struct YJColumn {
    YJDatabaseType type;
    char *name;
};
typedef struct YJColumn YJColumn,*YJColumnRef;
void freeYJColumn(YJColumnRef);

YJStatus openDatabase(const char *path,sqlite3 **sqlite);
YJStatus closeDatabase(sqlite3 *database);
YJStatus handleWithSql(const char *sql,sqlite3 *database);
YJStatus getIntValueWithSql(const char *sql,int *value,sqlite3 *database);
YJStatus copyStrVaueWithSql(const char *sql,char **value,sqlite3 *database);
YJStatus copyAllTableName(sqlite3 *database,YJStringRef *tableNames);
YJStatus copyAllColumnFromTable(sqlite3 *database,YJStringRef *column,const char *tableName);
YJStatus getColumnCountFromTable(sqlite3 *database,int *columnCount,const char *tableName);//未完成
#endif
