using CSV ,HTTP,DataFrames,DelimitedFiles,Dates,TimeZones


# 获取奖励类型及数量
function rewardInfo()
    rewards = CSV.read("TestReward.csv")
    rewardStr=""
    for i in 1:size(rewards, 2)
        item=rewards[1,i]
        if i%2==0
            rewardStr="$rewardStr$item,"
        else 
            rewardStr="$rewardStr$item:"
        end
    end
    rewardStr=rstrip(rewardStr, ',')
    return rewardStr
end




# # 获取rid
function allrid()
    allRids = CSV.read("roles.csv")
    sucRid=CSV.read("success.csv")
    println(sucRid)
    ridAry=[]
    for i in 1:size(allRids,1)
        push!(ridAry,allRids[i,:].RID[1])
    end 
    return ridAry
end


# 统一写入数据
function writeRes(reponses)
    i="re"
    filename=string(i, ".csv")  
    fileio = open(filename, "w")    #新建文件名为filename的文件
    #循环写入文件中
    for i in 1:size(ridAry,1)
        writedlm(fileio, [ridAry[i] reward reponses[i]])
    end
    close( fileio) #关闭文件
end



# 发送请求
function requests()
    println(ridAry)
    reponses=[]
    for i in 1:size(ridAry,1)
        data="rid=$(ridAry[i])&items=$reward"
        # r = HTTP.request("GET", "http://10.0.21.16:19527/senditemmail?$data"; verbose=3)
        # itemRes=String(r.body)
        # itemRes=itemRes==""?"falied":"success"
        itemRes="success"
        push!(reponses,itemRes) 
    end
    writeRes(reponses)
end


# requests();
println(localzone())











