using CSV , DataFrames ,Dates

# 获取奖励及邮件相关信息
function rewardInfo()
    mydata = CSV.read("TestReward.csv")
    nrows, ncols = size(mydata)
    title=mydata[1,:STR_MAIL_TITLE] 
    subtitle=mydata[1,:STR_MAIL_SHORT]
    content=mydata[1,:STR_MAIL_DETAIL]
    reward=""
    for col in 1:ncols
        if  occursin("INT_REWARD_TYPE", String(names(mydata)[col]))
            reward="$reward$(mydata[1,col]):"
        end
        if  occursin("INT_REWARD_COUNT", String(names(mydata)[col]))
            reward="$reward$(mydata[1,col]),"
        end
    end
    reward=rstrip(reward, ',')
    rewardData="title=$title&subtitle=$subtitle&content=$content&items=$reward"
    return rewardData
end



# 获取文件中的rid 
function getrids(filename)
    rids = CSV.read(filename)
    ridAry=[]
    for i in 1:size(rids,1)
        if !(ismissing(rids[i,:RID]))
            push!(ridAry,rids[i,:RID])
        end
    end 
    return ridAry
end


# 对所有的rid和已成功的rid进行对比
function rid()
    allRid=getrids("roles.csv")
    sucRid=getrids("success.csv")
    results=[]
    for i in 1:size(allRid,1)
        if !(allRid[i] in sucRid)
            push!(results,allRid[i])
        end
    end
    return results
end


# 统一写入数据
function writeRes(filename,rids)
    if length(rids)<=0 return end
    filerids=getrids(filename)
    resultRid=vcat(filerids,rids)
    ptable = DataFrame(RID=resultRid)
    CSV.write(filename,ptable)
end


# 每个请求分为单个任务
function mytask(ridAry)
    for i in 1:size(ridAry,1)
        put!(jobs, i)
    end
end;



function do_work(ridAry,rewardData)
    for i in jobs
        data="rid=$(ridAry[i])&$rewardData"
        result=String(read(`curl -d "$(data)" http://10.0.21.16:19527/senditemmail`))
        time=Dates.now()
        put!(results, ("$(ridAry[i]).$result", time))
    end
end;