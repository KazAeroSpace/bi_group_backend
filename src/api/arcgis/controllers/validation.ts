const { yup, validateYupSchema } = require("@strapi/utils");

const getTokenSchema = yup.object({
  referer: yup.string().required(),
})

export const validateGetTokenBody = validateYupSchema(getTokenSchema)
