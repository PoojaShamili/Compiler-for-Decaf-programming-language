/*

⟨program⟩ → class Program ′{′ ⟨field_decl⟩∗
 ⟨statement_decl⟩∗
 ′}′ 
 
⟨field_decl⟩ → ⟨type⟩ {⟨id⟩ | ⟨id⟩ ′[′ ⟨int_literal⟩ ′]′ }+, ; 
 
⟨statement_decl⟩ → ⟨location⟩ ⟨assign_op⟩ ⟨expr⟩ ;  
| callout ( ⟨string_literal⟩ [, ⟨callout_arg⟩+,] ) ; 

 */

class ASTnode
{
//	public:
//	virtual void accept(class Visitor &v)=0;
};

class ASTProgram : public ASTnode
{
 	list<ASTstatement_decl_node *> *statement_list;
 	list<ASTfield_decl_node*> *field_list;

public:
	ASTProgram(list<ASTfield_decl_node *> *f, list<ASTstatement_decl_node *> *s) : field_list (f), statement_list (s) {}
	//~Program();

};


class ASTstatement_decl_node
{

};


class ASTstatement_location_node : ASTstatement_decl_node
{
	ASTlocation_node* location;
	ASTexpr_node* expr; 

public:
	ASTstatement_location_node(ASTlocation_node* l, string s, ASTexpr_node* e) : location (l), expr (e) {}
};

class ASTstatement_callout_node : ASTstatement_decl_node
{
	string String;
	list<ASTarg *> *args; 

public:
	ASTstatement_callout_node(string s, list<ASTargs *> *a) : String (s), args (a) {}
};

class ASTfield_decl_node
{
	string Type;
	list<ASTidlist *> *idlist; //implement

public:
	ASTfield_decl_node(string t, list<ASTidlist *> *i) : Type (t), idlist (i) {}
};

class ASTtype 
{
	string type;
public:
	ASTtype(string s) : type (s) {}
};

class ASTlocation_node
{
	
};

class ASTlocation_single : public ASTlocation_node
{
	ASTidlist* idlist;
	ASTassign_op* assign_op;

public:
	ASTlocation_single(ASTidlist* i, ASTassign_op* s) : idlist (i), assign_op (s) {}

};

class ASTlocation_array : public ASTlocation_node
{
	ASTidlist* idlist;
	ASTassign_op* assign_op;
	ASTexpr_node* expr;
public:
	ASTlocation_array(ASTidlist* il, ASTassign_op* s, ASTexpr_node* e) : idlist (i), assign_op (s), expr (e) {}
};

class ASTassign_op
{
	string as_op;
public:
	ASTassign_op(string s) : as_op (s) {}
};

class ASTexpr_node 
{

};

class ASTunary_expr_node : public ASTexpr_node
{
	ASTexpr_node* expr;

public:
	ASTunary_expr_node(ASTexpr_node* e) : expr (e) {}
};

class ASTbinary_expr_node : public ASTexpr_node
{
	ASTexpr_node* left;
	ASTexpr_node* right;
	string op;

public:
	ASTbinary_expr_node(ASTexpr_node* l, ASTexpr_node* r, string s) : left (l), right (r), op (s) {}
};

class ASTidentifier : public ASTexpr_node
{
	ASTidlist *idlist;
public:
	ASTidentifier(ASTidlist* il) : idlist (il) {}

};

class ASTliteral : public ASTexpr_node
{
	string lit;
public:
	ASTliteral(string s) : lit (s) {}
};

class ASTint : public ASTexpr_node
{
	int i;
public:
	ASTint(int in) : i (in) {}
};

class ASTarg 
{

};

class ASTarg_expr : public ASTarg
{
	ASTexpr_node* expr;

public:
	ASTarg_expr(ASTexpr_node* e) : expr (e) {}
};

class ASTarg_string : public ASTarg
{
	string s;

public:
	ASTarg_string(string st) : s (st) {}
};

class ASTidlist
{

};

class ASTid : public ASTidlist
{
	string var;

public:
	ASTid(string v) : var (v) {}
};

class ASTid_string : public ASTidlist
{
	string var;
	int value;

public:
	ASTid_string(string va, int v) : var(va), value(v) {}
};